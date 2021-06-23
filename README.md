# Recomendador
El desafío: Construir un sistema de recomendación para predecir que nuevos contenidos, no previamente vistos, son más probables a ser elegidos para ver en Flow por un grupo de usuarios basándose en su historial de visualizaciones
Evaluación:  
Se deberá entregar un listado de veinte (20) nuevos contenidos, no previamente vistos, de cada uno de los usuarios que se encuentren en de la base de entrenamiento 



Métrica:  

Las cargas serán evaluadas utilizando mean Average Precision sobre el listado de 20 candidatos a recomendar (mAP@20) 

mAP se basa en las siguientes premisas: 

Relevancia del contenido: se haya visto al menos una vez en el set de testeo, correspondiente al mes a predecir 

posición (orden):  

 

MAP (Mean Average Precision) es una medida estándar para comparar la lista completa de Q elementos recomendados.  

La precisión promedio (AP) es el promedio de los valores de precisión en todos los rangos donde se encuentran los items relevantes. Luego, los valores de AP se promedian sobre el conjunto de consultas (aritméticamente ) 

Hay un baseline de la métrica a superar 
