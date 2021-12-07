import numpy as np
import tensorflow as tf
from matplotlib import pyplot as plt
import keras
from keras import layers
from keras.layers import Input, ZeroPadding1D, Flatten, Conv1D, AveragePooling1D, Dense, MaxPooling1D, Dropout, BatchNormalization
from keras.optimizers import Adam
from keras.models import Sequential
from keras.models import Model
from keras.callbacks import EarlyStopping
from tensorflow.python.keras.activations import softsign
import time

np.random.seed(2)

#  Definimos el número de clases que se tienen
clases = 19

# Se cargan las BOFs y etiquetas de las figuras
bofs = np.load("bofs19_ten.npy")
labels = np.load("labels19_ten.npy")

labels = labels.T

# Definimos un nuevo arreglo que contenga las BOFs y las etiquetas en uno solo para no perder sus etiquetas antes de mezclarlas
X_input = np.c_[bofs.reshape(len(bofs), -1), labels.reshape(len(labels), -1)]

# Mezclamos aleatoriamente el conjunto de BOFs antes de dividirlo
np.random.shuffle(X_input)

# Dividimos el 60% de BOFs para el conjunto de entrenamiento, 20% para el conjunto de validación y 20% para el de prueba.
train_num = int(bofs.shape[0] * 60 / 100)
val_num = int((bofs.shape[0] - train_num) / 2)

# Copiamos el número de BOFs correspondientes a cada conjunto
X_train = np.copy(X_input[0 : train_num, 0:180])
X_test = np.copy(X_input[train_num : (train_num + val_num), 0:180])
X_val = np.copy(X_input[(train_num + val_num) : bofs.shape[0]-1, 0:180])


# time.sleep(3)

Y_train = np.zeros((train_num, clases))
Y_test = np.zeros((val_num, clases))
Y_val = np.zeros((val_num, clases))

prueba_l = np.zeros((1, X_test.shape[0]))
ind = 0

# Definimos las etiquetas de cada clase en cada conjunto
for x in range(train_num):
    Y_train[x, int(X_input[x, 180])] = 1

for x in range(train_num, (train_num + val_num)):
    Y_test[x - train_num, int(X_input[x, 180])] = 1
    
#     if(ind < X_test.shape[0]):
#         prueba_l[0, ind] = int(X_input[x, 180])
#         ind = ind + 1;

# np.save("bofs_labels.npy", prueba_l)
# time.sleep(3)

for x in range((train_num + val_num), bofs.shape[0]-1):
    Y_val[x - (train_num + val_num), int(X_input[x, 180])] = 1

# expandimos las dimensiones de los conjuntos para que coincidan con los requerimientos de keras
X_train = np.expand_dims(X_train, 2)
X_test = np.expand_dims(X_test, 2)
X_val = np.expand_dims(X_val, 2)

# print(X_test.shape)
# np.save("bofs60_prueba2.npy", X_test[0:60, :, :])
# time.sleep(5)

# Declaramos el modelo
model = keras.Sequential()

# Agregamos la primera capa convolucional de 1D con 6 filtros de tamaño 3 y aplicamos Average Pooling
model.add(layers.Conv1D(filters = 5, kernel_size = 5, strides = 1, padding = 'valid', activation = 'relu', input_shape = (X_train.shape[1], 1)))
model.add(layers.MaxPooling1D(pool_size = 2, strides = 2))

# Agregamos la segunda capa convolucional de 1D con 16 filtros de tamaño 5 y aplicamos Average Pooling
model.add(layers.Conv1D(filters = 8, kernel_size = 5, strides = 1, padding = 'valid', activation = 'relu'))
model.add(layers.MaxPooling1D(pool_size = 2, strides = 2))

# Agregamos la tercera capa convolucional de 1D con 28 filtros de tamaño 5 y aplicamos Average Pooling
model.add(layers.Conv1D(filters = 12, kernel_size = 5, strides = 1, padding = 'valid', activation = 'relu'))
model.add(layers.MaxPooling1D(pool_size = 2, strides = 2))

# Agregamos la cuarta capa convolucional de 1D con 34 filtros de tamaño 5 y aplicamos Average Pooling
model.add(layers.Conv1D(filters = 25, kernel_size = 5, strides = 1, padding = 'valid', activation = 'relu'))
model.add(layers.MaxPooling1D(pool_size = 2, strides = 2))

# Acomodamos la salida de la última capa como un solo vector columna
model.add(layers.Flatten())

# Agregamos la quinta capa, formada por 120 neuronas totalmente conectadas y utilizamos el método de Dropout para mejorar el desempeño de la red
model.add(layers.Dense(units = 90, activation = 'relu'))
model.add(Dropout(0.5))

# Agregamos la sexta capa formada por 84 neuronas totalmente conectadas
model.add(layers.Dense(units = 84, activation = 'relu'))

# Agregamos la séptima y última capa formada por la cantidad de clases y activación softmax
model.add(layers.Dense(units = clases, activation = 'softmax'))

model.summary()

# Utilizamos Adam como optimizador con una tasa de aprendizaje de 0.001
model.compile(loss = "categorical_crossentropy", optimizer = Adam(learning_rate = 0.001), metrics = ['accuracy', 'Recall', 'Precision', 'TruePositives', 'TrueNegatives', 'FalsePositives', 'FalseNegatives'])

# Definimos la cantidad de épocas, el tamaño de lotes a utilizar y el conjunto de validacion para entrenar la red
# epochs = 600
history = model.fit(x = X_train, y = Y_train, epochs = 10, batch_size = 32, validation_data = (X_val, Y_val))

# Evaluamos la red entrenada con el conjunto de prueba
preds = model.evaluate(x = X_test, y = Y_test)

print()
print ("Loss = " + str(preds[0]))
print ("Test Accuracy = " + str(preds[1]))

for x in range(100):

    y = np.copy(X_test[x, :, 0])
    y = np.expand_dims(y, 1)
    y = y.T
    y = np.expand_dims(y, 2)

    inicio = time.time()

    pred = np.argmax(model.predict(y))


    print(str(time.time() - inicio))

print()
print('CNN: ' + str(pred))
print('Clase real: ' + str(np.argmax(Y_test[500, :])))
print()

# Guardamos el modelo entrenado
# model.save('CNN_BOF.h5')

# print(history.history.keys())


# Imprimimos las gráficas de pérdida y exactitud
fig, axs = plt.subplots(nrows = 2, ncols = 1)
axs[0].plot(history.history['accuracy'])
axs[0].plot(history.history['val_accuracy'])
axs[0].set_title('Exactitud del Modelo')
axs[0].set_ylabel('Exactitud')
axs[0].set_xlabel('Época')
axs[0].legend(['entrenamiento', 'validación'], loc = 'upper left')

axs[1].plot(history.history['loss'])
axs[1].plot(history.history['val_loss'])
axs[1].set_title('Pérdida del Modelo')
axs[1].set_ylabel('Pérdida')
axs[1].set_xlabel('Época')
axs[1].legend(['entrenamiento', 'validación'], loc = 'upper right')

plt.show()

fig, axs = plt.subplots(nrows = 2, ncols = 1)
axs[0].plot(history.history['precision'])
axs[0].plot(history.history['val_precision'])
axs[0].set_title('Precisión del Modelo')
axs[0].set_ylabel('Precisión')
axs[0].set_xlabel('Época')
axs[0].legend(['entrenamiento', 'validación'], loc = 'upper left')

axs[1].plot(history.history['recall'])
axs[1].plot(history.history['val_recall'])
axs[1].set_title('Exhaustividad del Modelo')
axs[1].set_ylabel('Exhaustividad')
axs[1].set_xlabel('Época')
axs[1].legend(['entrenamiento', 'validación'], loc = 'upper left')

plt.show()

# fig = plt.figure()
# plt.plot(history.history['true_positives'])
# plt.plot(history.history['val_true_positives'])
# fig.suptitle('Positivos Verdaderos del Modelo')
# plt.ylabel('PV')
# plt.xlabel('Época')
# fig.legend(['entrenamiento', 'validación'], loc = 'upper left')
# plt.show()

# fig = plt.figure()
# plt.plot(history.history['true_negatives'])
# plt.plot(history.history['val_true_negatives'])
# fig.suptitle('Negativos Verdaderos del Modelo')
# plt.ylabel('NV')
# plt.xlabel('Época')
# fig.legend(['entrenamiento', 'validación'], loc = 'upper left')
# plt.show()

# fig = plt.figure()
# plt.plot(history.history['false_positives'])
# plt.plot(history.history['val_false_positives'])
# fig.suptitle('Positivos Falsos del Modelo')
# plt.ylabel('PF')
# plt.xlabel('Época')
# fig.legend(['entrenamiento', 'validación'], loc = 'upper left')
# plt.show()

# fig = plt.figure()
# plt.plot(history.history['false_negatives'])
# plt.plot(history.history['val_false_negatives'])
# fig.suptitle('Negativos Falsos del Modelo')
# plt.ylabel('NF')
# plt.xlabel('Época')
# fig.legend(['entrenamiento', 'validación'], loc = 'upper left')
# plt.show()