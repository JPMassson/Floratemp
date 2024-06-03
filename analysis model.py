import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeRegressor
from sklearn.metrics import mean_squared_error
from sklearn.preprocessing import StandardScaler
from keras.models import Sequential
from keras.layers import Dense
from keras.callbacks import EarlyStopping

# 读取数据
data = pd.read_csv('cleaned_melbourne_temperature.csv')
# data = pd.read_csv('cleaned_sydney_temperature.csv')


# print(data.count())

X = data[['Month', 'Day', 'Days of accumulation of maximum temperature']]
y = data['Maximum temperature (Degree C)']  # city temperature


X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)


dt_model = DecisionTreeRegressor()
dt_model.fit(X_train, y_train)

# 预测
y_pred_dt = dt_model.predict(X_test)


scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

model = Sequential()
model.add(Dense(64, activation='relu', input_shape=(X_train_scaled.shape[1],)))
model.add(Dense(32, activation='relu'))
model.add(Dense(1))  # 线性输出层

model.compile(optimizer='adam', loss='mean_squared_error')
early_stopping = EarlyStopping(patience=10, restore_best_weights=True)

model.fit(X_train_scaled, y_train, validation_data=(X_test_scaled, y_test), epochs=100, callbacks=[early_stopping])


y_pred_dl = model.predict(X_test_scaled)


y_pred_combined = (y_pred_dt + y_pred_dl.flatten()) / 2  # average value


mse_dt = mean_squared_error(y_test, y_pred_dt)
mse_dl = mean_squared_error(y_test, y_pred_dl)
mse_combined = mean_squared_error(y_test, y_pred_combined)

print("Tree model MSE:", mse_dt)
print("Deep learning model MSE:", mse_dl)
print("Model integration MSE:", mse_combined)