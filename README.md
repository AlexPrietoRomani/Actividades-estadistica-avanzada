# Advanced Statistics Course - Time Series Analysis and Regression

This repository contains two main activities as part of an advanced statistics course in a master's program. The focus is on performing comprehensive time series and regression analyses using R.

## Activities Overview 

### Activity 1: Regression Analysis
The first activity involves conducting a detailed regression analysis. This includes data preparation, model fitting, and interpretation of results to address specific research questions or hypotheses related to the dataset.

#### Key Steps:
- **Data Loading and Cleaning:** The dataset is loaded and cleaned, handling missing values and formatting columns appropriately.
- **Exploratory Data Analysis (EDA):** Visual and statistical summaries of the data are generated to understand underlying patterns.
- **Model Fitting:** Various regression models are fitted to the data, and their performances are compared using appropriate metrics.
- **Interpretation:** Results are interpreted to derive meaningful insights about the relationships between variables.

### Activity 2: Time Series Analysis
This activity involves the analysis of daily temperature data over a period using time series methods. The goal is to describe the data statistically, decompose it into components, model it appropriately, and make forecasts.

#### Key Steps:
1. **Data Description:**
   - The dataset contains daily records of maximum and minimum temperatures from 1935 onwards.
   - Missing values indicated by -99.9 were handled by replacing them with NA and removing incomplete cases.
   - Daily average temperatures were calculated as the mean of the maximum and minimum temperatures.

2. **Statistical Analysis:**
   - Summary statistics including mean, median, standard deviation, variance, minimum, and maximum values were computed.
   - Key findings include an average daily temperature of approximately 22.75°C with a standard deviation of 3.22°C.

3. **Data Visualization:**
   - A histogram of daily average temperatures shows a nearly normal distribution centered around 22°C.
   - A boxplot reveals the presence of some outliers, mostly on the lower side, indicating occasional drops in temperature.

4. **Time Series Creation:**
   - A time series object was created using the daily average temperatures with a frequency set to 365.25, accounting for leap years.
   
5. **Stationarity Testing:**
   - The Augmented Dickey-Fuller (ADF) test indicated that the series is stationary with a p-value of 0.01, allowing us to reject the null hypothesis of non-stationarity.

6. **Time Series Decomposition:**
   - The series was decomposed into trend, seasonal, and remainder components using STL (Seasonal and Trend decomposition using Loess).
     - **Trend:** Captures long-term movements in the data, possibly linked to climatic changes.
     - **Seasonal:** Exhibits yearly cycles, reflecting expected seasonal temperature variations.
     - **Remainder:** Represents the residual fluctuations after removing the trend and seasonal components.

7. **Autocorrelation Analysis:**
   - ACF and PACF plots showed significant correlations up to several lags, indicating potential seasonal patterns.
   - This information guided the selection of an appropriate ARIMA model.

8. **Spectral Analysis:**
   - Spectral density estimation confirmed dominant seasonal frequencies, validating the visual findings from the decomposition.

9. **Model Fitting:**
   - An ARIMA model was fitted, taking into account the identified autoregressive and moving average components.
   - Diagnostic checks, including residual ACF and PACF, confirmed the model adequacy, though minor adjustments were necessary for optimal performance.

10. **Model Diagnostics:**
    - The Ljung-Box test on residuals suggested that no significant autocorrelation remained, indicating a good model fit.
    - Normality tests and Q-Q plots of residuals confirmed that residuals approximately follow a normal distribution.

## Installation and Setup
To run the analyses yourself, clone this repository and ensure that you have R installed with the following packages:
- `ggplot2`
- `forecast`
- `tseries`
- `dplyr`
- `readr`

Install the required packages using:
```R
install.packages(c("ggplot2", "forecast", "tseries", "readr", "dplyr"))
```

## Usage
Detailed scripts and data can be found in the respective folders for Activity 1 and Activity 2. Each script is well-commented and organized to guide you through the process from data loading to final analysis and visualization.

## References
- Menne, M. J., et al. (2012). Global Historical Climatology Network – Daily (GHCN-Daily). Version 3. NOAA National Climatic Data Center.
- Hyndman, R. J., & Athanasopoulos, G. (2018). Forecasting: principles and practice. OTexts.
- Dickey, D. A., & Fuller, W. A. (1979). Distribution of the estimators for autoregressive time series with a unit root. Journal of the - - American Statistical Association, 74(366a), 427-431.

## Contributing
Feel free to fork this repository and submit pull requests. Contributions are welcome, especially in improving the code, adding new models, or refining the README.

## License
This project is licensed under the MIT License - see the LICENSE.md file for details.

## Contact
For any questions or feedback, please contact Alex Anthony Prieto Romani at alexprieto1997@gmial.com.

# Versión Español

Este repositorio contiene dos actividades principales como parte de un curso de estadística avanzada en un programa de máster. Se centra en la realización de análisis exhaustivos de series temporales y regresión utilizando R.

## Actividades 

### Actividad 1: Análisis de Regresión
La primera actividad consiste en realizar un análisis de regresión detallado. Esto incluye la preparación de los datos, el ajuste del modelo, y la interpretación de los resultados para abordar preguntas específicas de investigación o hipótesis relacionadas con el conjunto de datos.

#### Pasos clave:
- Carga y limpieza de los datos:** Se carga y limpia el conjunto de datos, se tratan los valores que faltan y se da el formato adecuado a las columnas.
- Análisis exploratorio de datos (AED):** Se generan resúmenes visuales y estadísticos de los datos para comprender los patrones subyacentes.
- Ajuste de modelos:** Se ajustan varios modelos de regresión a los datos y se comparan sus resultados utilizando las métricas adecuadas.
- Interpretación:** Los resultados se interpretan para obtener información significativa sobre las relaciones entre las variables.

### Actividad 2: Análisis de series temporales
Esta actividad consiste en el análisis de datos diarios de temperatura a lo largo de un periodo utilizando métodos de series temporales. El objetivo es describir los datos estadísticamente, descomponerlos en componentes, modelizarlos adecuadamente y hacer previsiones.

#### Pasos clave:
1. **Descripción de los datos**
   - El conjunto de datos contiene registros diarios de temperaturas máximas y mínimas a partir de 1935.
   - Los valores perdidos indicados por -99,9 se trataron sustituyéndolos por NA y eliminando los casos incompletos.
   - Las temperaturas medias diarias se calcularon como la media de las temperaturas máximas y mínimas.

2. **Análisis estadístico**
   - Se calcularon las estadísticas resumidas, incluyendo la media, la mediana, la desviación estándar, la varianza y los valores mínimo y máximo.
   - Los resultados clave incluyen una temperatura media diaria de aproximadamente 22,75°C con una desviación estándar de 3,22°C.

3. **Visualización de datos**
   - Un histograma de las temperaturas medias diarias muestra una distribución casi normal centrada en torno a los 22°C.
   - Un diagrama de caja revela la presencia de algunos valores atípicos, sobre todo en el lado inferior, que indican descensos ocasionales de la temperatura.

4. **Creación de series temporales**
   - Se ha creado un objeto de serie temporal utilizando las temperaturas medias diarias con una frecuencia fijada en 365,25, teniendo en cuenta los años bisiestos.
   
5. **Pruebas de estacionariedad**
   - La prueba de Dickey-Fuller aumentado (ADF) indica que la serie es estacionaria con un valor p de 0,01, lo que nos permite rechazar la hipótesis nula de no estacionariedad.

6. **Descomposición de la serie temporal:**
   - La serie se descompuso en componentes de tendencia, estacionales y remanentes utilizando STL (Seasonal and Trend decomposition using Loess).
     - **Tendencia:** Captura los movimientos a largo plazo de los datos, posiblemente vinculados a cambios climáticos.
     - Estacional:** Muestra los ciclos anuales, reflejando las variaciones estacionales de temperatura esperadas.
     - **Remanente:** Representa las fluctuaciones residuales tras eliminar los componentes de tendencia y estacionales.

7. **Análisis de autocorrelación**
   - Los gráficos ACF y PACF mostraron correlaciones significativas hasta varios retardos, lo que indica posibles patrones estacionales.
   - Esta información guió la selección de un modelo ARIMA apropiado.

8. **Análisis espectral**
   - La estimación de la densidad espectral confirmó las frecuencias estacionales dominantes, validando los resultados visuales de la descomposición.

9. **Ajuste del modelo**
   - Se ajustó un modelo ARIMA, teniendo en cuenta los componentes autorregresivos y de media móvil identificados.
   - Las comprobaciones diagnósticas, incluidas la ACF residual y la PACF, confirmaron la adecuación del modelo, aunque fueron necesarios pequeños ajustes para un rendimiento óptimo.

10. **Diagnóstico del modelo**
    - La prueba de Ljung-Box sobre los residuos indicó que no quedaba ninguna autocorrelación significativa, lo que indica un buen ajuste del modelo.
    - Las pruebas de normalidad y los gráficos Q-Q de los residuos confirmaron que éstos siguen aproximadamente una distribución normal.

## Instalación y configuración
Para ejecutar los análisis usted mismo, clone este repositorio y asegúrese de tener instalado R con los siguientes paquetes:
- `ggplot2`
- previsión
- `tseries
- `dplyr`
- `readr`

Instale los paquetes necesarios utilizando:
```R
install.packages(c(«ggplot2», «forecast», «tseries», «readr», «dplyr»))
```

## Uso
Los scripts detallados y los datos se pueden encontrar en las carpetas respectivas de la Actividad 1 y la Actividad 2. Cada script está bien comentado y organizado para guiarle a través del proceso desde la carga de datos hasta el análisis final y la visualización.