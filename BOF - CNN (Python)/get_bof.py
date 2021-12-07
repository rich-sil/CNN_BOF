import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
import cv2
import imutils

nom = ['cruz/', 'cubo/', 'engrane/', 'hexagono/', 'panal/', 'pastel/', 'persona/', 'piramide/', 'tornillo/', 'triangulo/', 
'arbol/', 'bigote/', 'caja/', 'corazon/', 'flor/', 'frijol/', 'lanza/', 'tubo/', 'ye/']

x_degree = 360
y_degree = 100

img_vert = 480
img_hor = 640

n_points = 180
samples = 324

distances = np.zeros((samples * len(nom), n_points))
labels = np.zeros((1, samples * len(nom)))

aux = 0

# Carga las imágenes en modo RGB
for i in range(len(nom)):
    for n in range(0, x_degree, 10):
        for m in range(10, y_degree, 10):
            img = np.array(Image.open(nom[i] + str(n) + '_' + str(m) + '.jpg'))
            print(nom[i] + ' ' + str(n) + ' ' + str(m))

            # Convierte de RGB a escala de grises usando los coeficientes para calcular la luminancia de acuerdo con Rec.ITU-R BT.601-7
            gray = (img[:, :, 0] * 0.299) + (img[:, :, 1] * 0.587) + (img[:, :, 2] * 0.114)

            # Redondeamos el arreglo y lo convertimos de float a uint8
            gray = np.around(gray).astype(np.uint8)
            
            plt.imshow(gray, cmap = 'gray')
            plt.show()

            # Aplicamos un filtro gaussiano para eliminar las altas frecuencias
            gray = cv2.GaussianBlur(gray, (5, 5), 0)

            plt.imshow(gray, cmap = 'gray')
            plt.show()

            #  Usamos 115 como valor límite para la conversión de escala de grises a binario
            thres = 115

            # Convertimos de escala de grises a binario
            b_w = cv2.threshold(gray, thres, np.amax(gray), cv2.THRESH_BINARY_INV)[1]

            # Mostramos la imagen en binario
            plt.imshow(b_w, cmap = 'Greys')
            plt.show()

            # Obtenemos las coordenadas que forman el contorno del objeto en la imagen binarizada
            contours = cv2.findContours(b_w, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)

            # Tomamos los valores apropiados del contorno
            contours = imutils.grab_contours(contours)

            # Establecemos los límites donde el centroide de la figura se debe encontrar
            x_limit = img_hor / 8
            y_limit = img_vert / 8
            cont = 0

            for c in contours:

                # Calculamos el centroide de las figuras encontradas
                M = cv2.moments(c)
                
                # Obtenemos las coordenadas del centroide
                if (M['m00'] != 0):
                    cX = int(M['m10'] / M['m00'])
                    cY = int(M['m01'] / M['m00'])
                else:
                    cX, cY = 0, 0

                # Si el centroide se encuentra dentro de los lìmites, se considera como el centroide de la figura
                if((cX >= x_limit and cY >= y_limit) and (cX < (x_limit * 7) and (cY < (y_limit * 7)))):
                
                    # Convertimos la lista de coordenadas del controno en un arreglo de numpy
                    contours = np.array(contours[cont]).reshape(len(contours[cont]), 2)
                    
                    # Obtenemos las coordenadas del contorno que son iguales a la coordenada en "x" de las coordenadas del centroide
                    coords = np.asarray(np.where(contours == cX)).T
                    pos = np.zeros((coords.shape[0]))

                    for k in reversed(range(0, coords.shape[0])):
                        if(coords[k, 1] == 1):
                            coords = np.delete(coords, (k), axis = 0)

                    coords = np.delete(coords, (1), axis = 1)
                    min_val = 1000
                    indice = 0
                    
                    # Comparamos las coordenadas de los pixeles encontrados para encontrar el que se encuentre a las 12 hr (0 grados)
                    for l in range (coords.shape[0]):
                        if (contours[coords[l, 0], 1] < min_val):
                            min_val = contours[coords[l, 0], 1];
                            indice = l;

                    indice = int(coords[indice])

                    #  Reorganizamos el contorno del arreglo de tal manera que el píxel a 0 grados sea el primer valor del arreglo
                    vals_2 = contours[0 : indice, :]
                    vals_1 = contours[indice : contours.shape[0], :]
                    contours = np.vstack((vals_1, vals_2))

                    # Extraemos solo 180 puntos de todo el contorno de la figura
                    space = int((contours.shape[0] / n_points) * 100)
                    space = space / 100

                    fig_contour = np.zeros((n_points, 2)).astype(int)

                    # A partir de los 180 puntos, se calcula la BOF de la figura
                    for g in range (n_points):
                        a = int(np.floor(space * g))

                        fig_contour[g, 0] = contours[a, 0]
                        fig_contour[g, 1] = contours[a, 1]


                    # Coloreamos el contorno y centroide de la figura en la imagen original
                    # cv2.circle(img, (cX, cY), 3, (255, 255, 255), -1)
                    # cv2.putText(img, nom[i] + ' ' + str(n) + ' ' + str(m), (cX - 150, cY - 20), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)

                    # for g in range (0, n_points, 4):
                    #     cv2.line(img, (cX, cY), (fig_contour[g, 0], fig_contour[g, 1]), (0, 0, 255), 1)
                    #     cv2.circle(img, (fig_contour[g, 0], fig_contour[g, 1]), 2, (255, 255, 255), -1)
                    #     cv2.circle(img, (fig_contour[g, 0], fig_contour[g, 1]), 2, (0, 0, 255), -1)
                    # cv2.circle(img, (fig_contour[0, 0], fig_contour[0, 1]), 3, (0, 255, 0), -1)

                    # Calculamos las distencia entre los 180 puntos y el centroide de la figura
                    distances[aux, :] = np.sqrt(np.sum((fig_contour - [cX, cY]) **2, axis = 1))

                    # Normalizamos las distancias
                    distances[aux, :] = distances[aux, :] / np.amax(distances[aux, :])

                    # Asignamos la etiqueta correcta a la bof de la figura
                    labels[0, aux] = i

                    
                    aux = aux + 1

                    # Mostramos la imagen 
                    # cv2.imshow("Image", img)
                    # cv2.waitKey(0)

                    # mostramos la gráfica de la BOF
                    # plt.plot(distances[0])
                    # plt.ylabel('Magnitud')
                    # plt.show()

                else:
                    print(nom[i] + ' ' + str(n) + ' ' + str(m))
                
                cont = cont + 1

                
# Guardamos la BOF de cada figura en un archivo de numpy
# np.save("bofs19_ten.npy", distances)
# np.save("labels19_ten.npy", labels)