# Taller de análisis de imágenes por software

## Propósito

Introducir el análisis de imágenes/video en el lenguaje de [Processing](https://processing.org/).

## Tareas

Implementar las siguientes operaciones de análisis para imágenes/video:

* Conversión a escala de grises: promedio _rgb_ y [luma](https://en.wikipedia.org/wiki/HSL_and_HSV#Disadvantages).
* Aplicación de algunas [máscaras de convolución](https://en.wikipedia.org/wiki/Kernel_(image_processing)).
* (solo para imágenes) Despliegue del histograma.
* (solo para imágenes) Segmentación de la imagen a partir del histograma.
* (solo para video) Medición de la [eficiencia computacional](https://processing.org/reference/frameRate.html) para las operaciones realizadas.

Emplear dos [canvas](https://processing.org/reference/PGraphics.html), uno para desplegar la imagen/video original y el otro para el resultado del análisis.

### Alternativas para video en Linux y `gstreamer >=1`

Distribuciones recientes de Linux que emplean `gstreamer >=1`, requieren alguna de las siguientes librerías de video:

1. [Beta oficial](https://github.com/processing/processing-video/releases).
2. [Gohai port](https://github.com/gohai/processing-video/releases/tag/v1.0.2).

Descompriman el archivo `*.zip` en la caperta de `libraries` de su sketchbook (e.g., `$HOME/sketchbook/libraries`) y probar cuál de las dos va mejor.

## Integrantes

Completar la tabla:

| Integrante      | github nick |
|-----------------|-------------|
| Daniel Pinzon   | daapinzonch |
| Christian Ortiz | cfortizp    |

## Discusión

El objetivo principal de este taller es realizar operaciones para analisis de imagenes y videos en el lenguaje Processing.

En primera instancia hicimos la conversión a escala de grises de las imágenes y del video en tiempo real, esto lo hicimos de tres formas distintas RGB Mean, Luma 601 y Luma 709, en las imágenes luego de aplicarse cualquiera de estas operaciones se puede apreciar un histograma que muestra la frecuencia de los pixeles en la imagen, se puede realizar la segmentación escogiendo un rango sobre el histograma, aquí solo se mostraran los pixeles que se encuentran dentro del rango y los demás se dejaran de color blanco.

![s](Recursos/Escala%20de%20Grises.JPG)

[!Escala de Grises(RGB Promedio) en Imágen. Segmentacion a partir de histograma](https://github.com/daapinzonch-cfortizp/ComputacionVisual/blob/master/Taller%20Analisis%20de%20Imagenes/Recursos/SegmentacionGrises.JPG)

Tambien se aplicaron algunas máscaras de convolución en las imagenes y en los videos en tiempo real, algunas de ellas como la Identity, Edge Detection (3 tipos distintos), Sharpen, Box Blur, Gaussian Blur entre otros.

[!Mascara(Edge Detection) en Imágen](https://github.com/daapinzonch-cfortizp/ComputacionVisual/blob/master/Taller%20Analisis%20de%20Imagenes/Recursos/Mascara.JPG)

En todas las operaciones que se realizaron en videos se puede medir la eficiencia computacional de estas, esto medido con una tasa de 30 fps y los resultados se encuentran entre 17 y 24, estos valores varían según la operación realizada.

[!Eficiencia Computacional en Video](https://github.com/daapinzonch-cfortizp/ComputacionVisual/blob/master/Taller%20Analisis%20de%20Imagenes/Recursos/FrameRate.JPG)

Por último para poder ver el trabajo realizado en este laboratorio se creó una ventana interactiva donde se pueden ver las operaciones realizadas a las imágenes y los videos, los histogramas y la eficiencia computacional. 

[!Ventana Interactiva](https://github.com/daapinzonch-cfortizp/ComputacionVisual/blob/master/Taller%20Analisis%20de%20Imagenes/Recursos/Interactiva.JPG)

## Entrega

* Plazo para hacer _push_ del repositorio a github: 29/9/19 a las 24h.
