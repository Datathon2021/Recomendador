# :vhs: Recomendador :vhs:

## El desafío: Construir un sistema de recomendación para predecir que nuevos contenidos, no previamente vistos, son más probables a ser elegidos para ver en Flow por un grupo de usuarios basándose en su historial de visualizaciones

## Evaluación:  
Se deberá entregar un listado de veinte (20) nuevos contenidos, no previamente vistos, de cada uno de los usuarios que se encuentren en de la base de entrenamiento 

## Métrica:  
Las cargas serán evaluadas utilizando mean Average Precision sobre el listado de 20 candidatos a recomendar (mAP) 

mAP es una medida estándar para comparar la lista completa de Q elementos recomendados. 
La precisión promedio (AP) es el promedio de los valores de precisión en todos los rangos donde se encuentran los items relevantes. Luego, los valores de AP se promedian sobre el conjunto de consultas (aritméticamente )

mAP se basa en las siguientes premisas: Relevancia del contenido: se haya visto al menos una vez en el set de testeo, correspondiente al mes a predecir posición (orden)

![image](https://user-images.githubusercontent.com/59797580/123177717-31a66400-d45c-11eb-8618-3decb9e16f05.png)

![image](https://user-images.githubusercontent.com/59797580/123177755-3e2abc80-d45c-11eb-985f-29a564a20da7.png)


## Baseline:
Hay un baseline de la métrica a superar 

## Codigo 

Tiene que ser código reproducible (OPEN SOURCE) 

## Entregables: 
### Resultados

Los resultados deben enviarse en un archivo .csv con la siguiente estructura: 
-Una columna que identifica a cada perfil con su id (account_id). 

-Otra columna con una lista de los veinte contenidos recomendados, identificados cada uno con su propio content_id y ordenados de mayor a menor relevancia predicha para cada perfil. La lista de definirse con corchetes ([]), y los elementos dentro de ella deben estar separados por coma. 

Ej: 123, [1,2,3,4,5, …, 20]. 

Los valores del csv deberán estar separados por comas, y las variables no deben tener cabecera. Para garantizar la concordancia de las predicciones con el set de testeo, los registros del csv deberán estar ordenados por account_id, de menor a mayor. 

### Código


## Datos :file_folder:

Una cohorte de 100k clientes con 4 meses de historia de visualizaciones   

Metadata asociada al contenido que vieron esos clientes (Año lanzamiento, director, género, categoria, keywords...)

Junto con los datos del desafío, proporcionamos un archivo de envío de muestra para ilustrar el formato esperado que acabamos de describir para asegurarnos de que no se pierda ningún detalle. 


### Evaluación Final
Una vez que el desafío finalice, los puntajes finales serán computados sobre un dataset de test privado.

### Tabla de posiciones
La tabla de posiciones se basa en el último envio de cada participante. 





