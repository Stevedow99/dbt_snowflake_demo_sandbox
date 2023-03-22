#Import required libraries
import pandas as pd
import numpy as np
from prophet import Prophet

#Import dbt library
#import dbt

def model(dbt, session):

    dbt.config(materialized="table", packages=['Prophet', 'pandas', 'numpy'])
    
    # Create a dataframe from the upstream model
    df = upstream_model = dbt.ref("fct_orders").toPandas()

    # column comes in as a string, convert it to a dt object
    df['order_month'] = pd.to_datetime(df['ORDER_DATE'])

    # date trunc the dt by converting to string and excluding day
    df['order_month'] = df['order_month'].dt.strftime("%Y-%m")

    # Create a dataframe with the sum of the amount for each month
    df_sum = df.groupby('order_month')['PAYMENT_AMOUNT'].sum().reset_index()

    # Rename columns
    df_sum.columns = ['ds', 'y']

    # Create and fit a Prophet model
    m = Prophet()
    m.fit(df_sum)

    # Create a dataframe to hold the forecast
    future = m.make_future_dataframe(periods=6, freq='M')

    # Make a forecast
    forecast = m.predict(future)

    # Create a dataframe with the forecast
    forecast_df = forecast[['ds', 'yhat']]

    return forecast_df;