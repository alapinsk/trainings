import numpy as np
from sklearn.cluster import KMeans
import pyodbc 
import pandas as pd
import matplotlib.pyplot as plt

# =======================================
server = '10.0.75.1,1433' 
database = 'WideWorldImporters' 
username = 'SA' 
password = 'SqlTest123!' 
cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
# =======================================

query1 = """
    SELECT CAST(AVG([AmountExcludingTax]) AS int) AS AvgAmountPaid
      ,COUNT(InvoiceID) AS InvoiceCnt
    FROM [WideWorldImporters].[Sales].[CustomerTransactions]
    GROUP BY CustomerID 
"""
df = pd.read_sql_query(query1, cnxn)
df = df[df['InvoiceCnt'] < 1000]


from sklearn.preprocessing import RobustScaler
scaler = RobustScaler()
df[['AvgAmountPaid','InvoiceCnt']] = scaler.fit_transform(df)



km = KMeans(n_clusters=4, random_state=0).fit(df)
km.labels_
km.cluster_centers_


plt.scatter(df['AvgAntPaid'], df['InvoiceCnt'], c=km.labels_)
plt.scatter(km.cluster_centers_[:,0] ,km.cluster_centers_[:,1], color='red')  
plt.show()
