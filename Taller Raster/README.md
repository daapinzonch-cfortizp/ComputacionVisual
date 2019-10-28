# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo.
2. Sombrear su superficie a partir de los colores de sus vértices.
3. Implementar un [algoritmo de anti-aliasing](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation) para sus aristas.

Referencias:

* [The barycentric conspiracy](https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/)
* [Rasterization stage](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-stage)

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [nub](https://github.com/visualcomputing/nub/releases) (versión >= 0.2).

## Integrantes

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
|Daniel Pinzón|daapinzonch|
|Christian Ortiz|cfortizp|
|Daniel Salgado|dasalgadob|

## Discusión

Describa los resultados obtenidos. En el caso de anti-aliasing describir las técnicas exploradas, citando las referencias.

### Rasterizar un triangulo

Por medio de la edge function se puede determinar de que lado se encuentra un punto respecto a una linea. Esta función da un valor negativo para cuando esta del lado izquierdo de la linea, 0 si encuentra en la linea y positivo si se encuentra al lado derecho de la linea. Para el caso del triangulo son 3 lineas y se debe comprobar que el punto a determinar se encuentre al lado derecho de las 3 lines que componen al triangulo.

Con este paso solo se determina si un pixel esta completamente a la derecha de todos los vectores que componen el triangulo. Pero aún no es suficiente para determinar su color especifico ya que para este se necesitan los 3 lambdas para saber el peso de cada punto.

### Sombreo de superficie

Para este caso las coordenadas baricentricas resultan muy util ya que permiten representar cualquier punto dentro del triangulo, en terminos de los 3 vectores que conforman el triangulo. Asignando 3 variables lambda las cuales sumadas entre si dan 1, una por cada vector que compone el triangulo. Por lo tanto a cada vertice se le asigna un color y con los lambdas resultantes de un determinado punto se puede asignar un color con pesos especificos para cada pixel que este en el area del triangulo.

Se puede observar que en la medida en la cual se tiene una escala mas pequeña de pixeles los bordes se van aproximando mas a una imagen mas nitida, pero debido a no tener el anti-aliasing implementado hace que sea muy evidente los bordes.

### Anti-aliasing

Para implementar el anti-aliasing es necesario dividir cada pixel en subcuadros. Luego con los conceptos de coordenadas baricentricas y la edge function se puede determinar cuantos de ellos estan incluidos dentro del triangulo. Finalmente con la cantidad de cuadrados que esten dentro del area del triangulo se puede determinar cuando porcentaje de color le corresponde y ponderarlo con el background.

Como resultado del anti-aliasing se ve un resultado mas fino ya que los colores de los bordes se vuelven mas semejantes al background de acuerdo a la ponderación calculada.

Referencias:
http://mathworld.wolfram.com/BarycentricCoordinates.html
https://computergraphics.stackexchange.com/questions/4248/how-is-anti-aliasing-implemented-in-ray-tracing

## Entrega

* Plazo: ~~20/10/19~~ 27/10/19 a las 24h.
