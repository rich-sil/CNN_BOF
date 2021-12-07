import numpy as np
import keras
from FixedPoint import FXfamily, FXnum
from fxpmath import Fxp
import random
import time

bofs = np.load("bofs60_prueba.npy")
labels = np.load("bofs60_labels.npy")

leng = 9
dec = 7

# y = np.copy(bofs[800, :])
# y = np.expand_dims(y, 1)
# y = y.T
# y = np.expand_dims(y, 2)

cnn_model = keras.models.load_model('CNN_BOF.h5')

conv_layer = keras.Model(inputs = cnn_model.input, outputs = cnn_model.layers[12].output)
# conv_data = conv_layer.predict(y)

# weights_conv1 = Fxp(cnn_model.layers[0].get_weights()[0], True, leng, dec).get_val()
# bias_conv1 = Fxp(cnn_model.layers[0].get_weights()[1], True, leng, dec).get_val()

# weights_conv2 = Fxp(cnn_model.layers[2].get_weights()[0], True, leng, dec).get_val()
# bias_conv2 = Fxp(cnn_model.layers[2].get_weights()[1], True, leng, dec).get_val()

# weights_conv3 = Fxp(cnn_model.layers[4].get_weights()[0], True, leng, dec).get_val()
# bias_conv3 = Fxp(cnn_model.layers[4].get_weights()[1], True, leng, dec).get_val()

# weights_conv4 = Fxp(cnn_model.layers[6].get_weights()[0], True, leng, dec).get_val()
# bias_conv4 = Fxp(cnn_model.layers[6].get_weights()[1], True, leng, dec).get_val()

# weights_dense1 = Fxp(cnn_model.layers[9].get_weights()[0], True, leng, dec).get_val()
# bias_dense1 = Fxp(cnn_model.layers[9].get_weights()[1], True, leng, dec).get_val()

# weights_dense2 = Fxp(cnn_model.layers[11].get_weights()[0], True, leng, dec).get_val()
# bias_dense2 = Fxp(cnn_model.layers[11].get_weights()[1], True, leng, dec).get_val()

# weights_dense3 = Fxp(cnn_model.layers[12].get_weights()[0], True, leng, dec).get_val()
# bias_dense3 = Fxp(cnn_model.layers[12].get_weights()[1], True, leng, dec).get_val()



weights_conv1 = cnn_model.layers[0].get_weights()[0]
bias_conv1 = cnn_model.layers[0].get_weights()[1]

weights_conv2 = cnn_model.layers[2].get_weights()[0]
bias_conv2 = cnn_model.layers[2].get_weights()[1]

weights_conv3 = cnn_model.layers[4].get_weights()[0]
bias_conv3 = cnn_model.layers[4].get_weights()[1]

weights_conv4 = cnn_model.layers[6].get_weights()[0]
bias_conv4 = cnn_model.layers[6].get_weights()[1]

weights_dense1 = cnn_model.layers[9].get_weights()[0]
bias_dense1 = cnn_model.layers[9].get_weights()[1]

weights_dense2 = cnn_model.layers[11].get_weights()[0]
bias_dense2 = cnn_model.layers[11].get_weights()[1]

weights_dense3 = cnn_model.layers[12].get_weights()[0]
bias_dense3 = cnn_model.layers[12].get_weights()[1]

# print(bof_test.shape)
print(cnn_model.summary())
# print(weights_dense3.shape)
# print(bias_dense3.shape)
# print(conv_data.shape)
print()

leng = 16
dec = 12

def conv_single_step(slice_prev, W, b):

    mult = np.zeros(W.shape)
    # suma = np.zeros((1, W.shape[1]))
    suma = 0.0
    Z = 0.0

    # print(slice_prev.shape)
    # print(W.shape)
    # print(b)

    # print("MULTIPLICACIONES")

    for i in range (slice_prev.shape[0]):
        for j in range (slice_prev.shape[1]):
            mult[i, j] = slice_prev[i, j] * W[i, j]

            # print()
            # print(slice_prev[i, j])
            # print(W[i, j])
            # print()

            # print(mult[i, j])

            # print(Fxp(W[i, j], True, 9, 7).hex(), end = " ")
            # print(Fxp(mult[i, j], True, leng, dec).hex())
            # time.sleep(1)

            # if (W.shape[1] == 12):
            #     print(i, end = ' ')
            #     print(j, end = " ")
            #     print(slice_prev[i, j], end = " ")
            #     print(Fxp(W[i, j], True, 9, 7).hex(), end = " ")
            #     print(Fxp(W[i, j], True, 9, 7).get_val(), end = " ")
            #     print(mult[i, j])
                # time.sleep(0.15)
        # print()
    
    # mult_1 = Fxp(mult, True, leng, dec, rounding = 'trunc').get_val()

    # print("SUMA")
    for i in range (mult.shape[0]):
        for j in range (mult.shape[1]):
            # suma = Fxp(suma + mult_1[i, j], True, leng, dec, rounding = 'trunc').get_val()
            suma = suma + mult[i, j]

            # if (W.shape[1] == 12):
            #     print(i, end = ' ')
            #     print(j, end = "    ")
            #     print(mult[i, j], end = "   ")
            #     print(suma)
            #     print()
                # time.sleep(0.15)

    # suma_1 = Fxp(suma, True, leng, dec).get_val()

    # for i in range (suma.shape[1]):
    #     Z = Fxp(suma[0, i] + Z, True, leng, dec).get_val()

    # Z = Fxp(suma + float(b), True, leng, dec, rounding = 'trunc').get_val()
    Z = suma + float(b)

    # if (W.shape[1] == 5):
        # print("BIAS")
        # print(b, end = "    Suma: ")
        # print(Z)
        # print()
        # print()

    # print(Fxp(b, True, 9, 7).hex(), end = " ")
    # print(Fxp(Z, True, leng, dec).hex())
    # time.sleep(1)

    # Shape 1 - Conv 1
    # Shape 5 - Conv 2
    # Shape 8 - Conv 3
    # Shape 12 - Conv 4

    if (W.shape[1] != 0):
        if (Z < 0):
            Z = 0

    # print(Fxp(Z, True, leng, dec, rounding = 'trunc').hex())
    # time.sleep(1)

    return Z

def conv_forward(A_prev, W, b, f):

    Z = np.zeros((A_prev.shape[0], A_prev.shape[1] - f + 1, W.shape[2]))
    
    # print(A_prev.shape)
    # print(Z.shape)
    # print(W.shape)

    for i in range(Z.shape[2]):

        # print()
        # print()
        # print(i, end = " Filter")
        # print()
        # if (Z.shape[2] == 25):
        #         time.sleep(3)

        for j in range(Z.shape[1]):
            slice_prev = A_prev[:, j : j + f].reshape(f, W.shape[1])

            Z[:, j, i] = conv_single_step(slice_prev, W[:, :, i], b[i])

            # if(Z.shape[2] == 25 and i == 1):
            #     print(i, end = " --- SLICE ---")
            #     print()
            #     Z[:, j, i] = conv_single_step(slice_prev, W[:, :, i], b[i])
            #     time.sleep(3)
            # else:
            #     Z[:, j, i] = conv_single_step(slice_prev, W[:, :, i], b[i])

            
            
    return Z    

def pool_forward(A_prev):

    f = 2
    stride = 2
    A = np.zeros((A_prev.shape[0], int(A_prev.shape[1] / 2), A_prev.shape[2]))

    for i in range(A.shape[2]):
        for j in range(A.shape[1]):
            slice_prev = A_prev[0, (j * stride) : (j * stride + f), i]
            A[0, j, i] = np.max(slice_prev)

    return A

mayor = 0.0
menor = 1000.0

def dense_forward(A, W, b, activation):

    # print(W.shape)

    global mayor
    global menor

    Z = np.zeros((1, W.shape[1]))

    for i in range (W.shape[1]):
        s = 0.0
        # time.sleep(3)
        for j in range (W.shape[0]):
            # print(Fxp(W[j, i], True, 9, 7).bin())
            # s = Fxp(s + A[0, j] * W[j, i], True, 12, 5, rounding = 'around').get_val()
            # s = Fxp(s + A[0, j] * W[j, i], True, 16, 8, rounding = 'around').get_val()
            s = s + A[0, j] * W[j, i]
            # print()
            # print(j, end = ". ")
            # print(A[0,j], end = "    ")
            # print(W[j, i], end = "    ")
            # print(A[0, j] * W[j, i], end = "    ")
            # print(s)


        # Z[0, i] = Fxp(s + b[i], True, 12, 5, rounding = 'around').get_val()
        # Z[0, i] = Fxp(s + b[i], True, 16, 8, rounding = 'around').get_val()
        Z[0, i] = s + b[i]
        # if (Z.shape[1] == 19):
        #     print(Z[0, i])

        if(activation == 'relu'):

            if(Z.shape[1] != 0):
                if(Z[0, i] < 0):
                    Z[0, i] = 0

    # print(Z)

    if(activation == 'softmax'):
        Z_exp = np.zeros(Z.shape)
        e = 2.71828182
        n = 0.0
        
        for k in range (Z_exp.shape[1]):
            Z_exp[0, k] = pow(e, Z[0, k])

            # print(Z_exp[0, k])

            n = Z_exp[0, k] + n

        print()
        for h in range (Z.shape[1]):
            # print(Z_exp[0, h] / n)
            Z[0, h] = Z_exp[0, h] / n
            # print(Z[0, h])

        # Z = Z_exp
            
    return Z

kernel = 5
error = 0.0
error_fp = 0.0
acc = 0
acc_fp = 0
i = 1
# muestras = 6155
muestras = 60
# random.seed(0)
# lista = random.sample(range(bofs.shape[0] - 1), muestras)

for j in range(muestras):

    # bof_test = Fxp(bofs[4000].copy().reshape(1, bofs.shape[1]), True, 9, 7).get_val()
    # label_real = labels[0, 4000]
    # y = np.copy(bofs[4000, :])
    y = np.copy(bofs[j, :])
    bof_test = bofs[j, :].copy().reshape(1, bofs.shape[1])
    label_real = labels[0, j]

    y = np.expand_dims(y, 1)
    y = y.T
    y = np.expand_dims(y, 2)

    print('BOF: ' + str(i))

    Conv1 = conv_forward(bof_test, weights_conv1, bias_conv1, kernel)
    # print(Conv1.shape, end = "Conv 1")
    # print()
    # # np.save("conv1_"+str(j+1)+".npy", Conv1)
    # Conv_1 = Conv1
    # for i in range(176):
    #     for j in range (5):
    #         # print(i, end = " => ")
    #         print(Conv_1[0,i,j])
    # time.sleep(3)

    Pool1 = pool_forward(Conv1)
    # print(Pool1.shape, end = "Pool 1")
    # print()
    # Pool_1 = Pool1
    # for i in range(Pool_1.shape[1]):
    #     for j in range(Pool_1.shape[2]):
    #         print(Pool_1[0, i, j])
    # time.sleep(3)

    Conv2 = conv_forward(Pool1, weights_conv2, bias_conv2, kernel)
    print(Conv2.shape, end = "Conv 2")
    # print()
    # # np.save("conv2_"+str(j+1)+".npy", Conv2)
    # Conv_2 = Conv2
    # for i in range(84):
    #     for j in range(8):
    #         # print(i, end = " => ")
    #         print(Conv_2[0,i,j])
    # time.sleep(3)

    Pool2 = pool_forward(Conv2)
    # print(Pool2.shape, end = "Pool 2")
    # print()
    # Pool_2 = Pool2
    # for i in range(Pool_2.shape[1]):
    #     for j in range(Pool_2.shape[2]):
    #         print(Pool_2[0, i, j])
    # time.sleep(3)

    Conv3 = conv_forward(Pool2, weights_conv3, bias_conv3, kernel)
    print(Conv3.shape, end = "Conv 3")
    # print()
    # # np.save("conv3_"+str(j+1)+".npy", Conv3)
    # Conv_3 = Conv3
    # for i in range(38):
    #     for j in range(12):
    #         # print(i, end = " => ")
    #         print(Conv_3[0,i,j])
    # time.sleep(3)

    Pool3 = pool_forward(Conv3)
    # print(Pool3.shape, end = "Pool 3")
    # print()
    # Pool_3 = Pool3
    # for i in range(Pool_3.shape[1]):
    #     for j in range(Pool_3.shape[2]):
    #         print(Pool_3[0, i, j])
    # time.sleep(3)

    Conv4 = conv_forward(Pool3, weights_conv4, bias_conv4, kernel)
    print(Conv4.shape, end = "Conv 4")
    # print()
    # # np.save("conv4_"+str(j+1)+".npy", Conv4)
    # Conv_4 = Conv4
    # for i in range(15):
    #     for j in range(25):
    #         # print(i, end = " => ")
    #         print(Conv_4[0,i,j])
    time.sleep(3)

    Pool4 = pool_forward(Conv4)
    # print(Pool4.shape, end = "Pool 4")
    # print()
    # Pool_4 = Pool4
    # for i in range(Pool_4.shape[1]):
    #     for j in range(Pool_4.shape[2]):
    #         print(Pool_4[0, i, j])
    # time.sleep(3)

    Flatten = Pool4.reshape(1, Pool4.shape[1] * Pool4.shape[2])
    print()

    Dense1 = dense_forward(Flatten, weights_dense1, bias_dense1, 'relu')
    # print(Dense1.shape, end = "Dense1")
    # print()
    # # np.save("dense1_"+str(j+1)+".npy", Dense1)
    # for i in range(Dense1.shape[1]):
    #     print(Dense1[0,i])
    # time.sleep(3)
    # print()

    Dense2 = dense_forward(Dense1, weights_dense2, bias_dense2, 'relu')
    # print(Dense2.shape, end = "Dense 2")
    # print()
    # np.save("dense2_"+str(j+1)+".npy", Dense2)
    # for i in range(Dense2.shape[1]):
    #     print(Dense2[0,i])
    # time.sleep(3)
    # print()

    Dense3 = dense_forward(Dense2, weights_dense3, bias_dense3, 'softmax')
    # print(Dense3.shape, end = "Dense 3")
    # print()
    # np.save("exp_"+str(j+1)+".npy", Dense3)
    # time.sleep(3)

    if(label_real == np.argmax(Dense3)):
        acc_fp = acc_fp + 1

    conv_data = cnn_model.predict(y)

    if(label_real == np.argmax(conv_data)):
        acc = acc + 1

    error = (acc / i * 100)
    error_fp = (acc_fp / i * 100)

    print()
    print("Clase real: ", end = " ")
    print(label_real)
    print(np.argmax(conv_data))
    print(np.argmax(Dense3))
    print()
    print('Accuracy: ' + str(error) + '%')
    print()
    print('Accuracy FP: ' + str(error_fp) + '%')
    i = i + 1

    # time.sleep(3)

print(mayor)
print(menor)
