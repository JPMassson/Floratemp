import pandas as pd

data = pd.read_csv('L:\\IDCJAC0010_086338_2023\\IDCJAC0010_086338_2023_Data.csv')
# data = pd.read_csv('L:\\IDCJAC0010_066214_2023\\IDCJAC0010_066214_2023_Data.csv')

print(data.head())

print("Number of missing：", data.isnull().sum())

data['Maximum temperature (Degree C)'].ffill(inplace=True)

print("Missing value after filling：", data.isnull().sum())

print("duplicate value：", data.duplicated().sum())

data.drop_duplicates(inplace=True)

data.to_csv('cleaned_melbourne_temperature.csv', index=False)
# data.to_csv('cleaned_sydney_temperature.csv', index=False)