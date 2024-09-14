# ---------------------------------
# Instalación de paquetes necesarios
# ---------------------------------

# Instalar paquetes si no están ya instalados
required_packages <- c("ggplot2", "forecast", "tseries", "readr", "dplyr")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]

if(length(new_packages)) install.packages(new_packages)

# Cargar las librerías necesarias
library(ggplot2)
library(forecast)
library(tseries)
library(readr)     # Para leer datos de manera más eficiente
library(dplyr)     # Para manipulación de datos

# ---------------------------------
# Carga de datos
# ---------------------------------

# Especificar el nombre y la ruta del archivo de datos
nombre_archivo <- "Actividad 2/qc00000320.txt"

# Construir la ruta completa al archivo
ruta_completa <- file.path(getwd(), nombre_archivo)

# Verificar si el archivo existe
if(!file.exists(ruta_completa)) {
  stop("El archivo especificado no existe en la ruta dada.")
}

# Especificar el nombre del archivo Excel
nombre_archivo <- "Actividad 2/qc00000320.txt"

# Construir la ruta completa al archivo
ruta_completa <- file.path(getwd(), nombre_archivo)

# Cargar los datos
data <- read.table(ruta_completa, header = FALSE, sep = " ")

# Exploración inicial de los datos
str(data)
head(data)
summary(data)

# ---------------------------------
# Preparación y limpieza de datos
# ---------------------------------

# Asignar nombres a las columnas
colnames(data) <- c("Año", "Mes", "Día", "Precipitación", "Temp_Max", "Temp_Min")

# Reemplazar valores -99.9 o -99.90 con NA para indicar datos faltantes
data[data == -99.9 | data == -99.90] <- NA

# Convertir las columnas numéricas apropiadamente
numeric_cols <- c("Precipitación", "Temp_Max", "Temp_Min")
data[numeric_cols] <- lapply(data[numeric_cols], as.numeric)

# Calcular la temperatura promedio diaria
data$Temp_Promedio <- rowMeans(data[, c("Temp_Max", "Temp_Min")], na.rm = TRUE)

# Crear una columna de fecha
data$Fecha <- as.Date(with(data, paste(Año, Mes, Día, sep = "-")), "%Y-%m-%d")

# Ordenar los datos por fecha
data <- data[order(data$Fecha), ]

# Eliminar filas con NA en la temperatura promedio o en la fecha
data <- data[complete.cases(data$Temp_Promedio, data$Fecha), ]

# Verificar los datos después de la limpieza
str(data)
head(data)
summary(data$Temp_Promedio)

# ---------------------------------
# Análisis estadístico descriptivo
# ---------------------------------

# Estadísticas descriptivas de la temperatura promedio
mean_temp <- mean(data$Temp_Promedio)
median_temp <- median(data$Temp_Promedio)
sd_temp <- sd(data$Temp_Promedio)
var_temp <- var(data$Temp_Promedio)
min_temp <- min(data$Temp_Promedio)
max_temp <- max(data$Temp_Promedio)
quantiles_temp <- quantile(data$Temp_Promedio)

# Mostrar las estadísticas
cat("Temperatura Promedio:\n")
cat("Media:", mean_temp, "\n")
cat("Mediana:", median_temp, "\n")
cat("Desviación Estándar:", sd_temp, "\n")
cat("Varianza:", var_temp, "\n")
cat("Mínimo:", min_temp, "\n")
cat("Máximo:", max_temp, "\n")
cat("Cuantiles:\n")
print(quantiles_temp)

# ---------------------------------
# Visualización de datos
# ---------------------------------

# Histograma de la temperatura promedio
ggplot(data, aes(x = Temp_Promedio)) +
  geom_histogram(binwidth = 1, fill = "skyblue", color = "black") +
  labs(title = "Histograma de la Temperatura Promedio Diaria",
       x = "Temperatura Promedio (°C)",
       y = "Frecuencia")

# Diagrama de caja (boxplot) de la temperatura promedio
ggplot(data, aes(y = Temp_Promedio)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Diagrama de Caja de la Temperatura Promedio Diaria",
       y = "Temperatura Promedio (°C)")

# Serie temporal de la temperatura promedio
ggplot(data, aes(x = Fecha, y = Temp_Promedio)) +
  geom_line(color = "blue") +
  labs(title = "Serie Temporal de la Temperatura Promedio Diaria",
       x = "Fecha",
       y = "Temperatura Promedio (°C)")

# ---------------------------------
# Creación de la serie temporal
# ---------------------------------

# Crear la serie temporal de la temperatura promedio
# Como los datos son diarios, la frecuencia es 365 (o 366 en años bisiestos)
# Para una mejor aproximación, podríamos usar frecuencia 365.25
ts_temp <- ts(data$Temp_Promedio, start = c(min(data$Año), min(data$Mes)), frequency = 365.25)

# Visualización inicial de la serie temporal
plot(ts_temp, main = "Serie Temporal de la Temperatura Promedio Diaria",
     ylab = "Temperatura (°C)", xlab = "Año", col = "darkgreen")

# ---------------------------------
# Descomposición de la serie temporal
# ---------------------------------

# Descomposición usando STL (Seasonal and Trend decomposition using Loess)
ts_decomp <- stl(ts_temp, s.window = "periodic")

# Visualización de la descomposición
plot(ts_decomp, main = "Descomposición STL de la Serie Temporal")

# ---------------------------------
# Análisis de autocorrelación
# ---------------------------------

# Gráfico de ACF
acf(ts_temp, main = "Función de Autocorrelación (ACF)")

# Gráfico de PACF
pacf(ts_temp, main = "Función de Autocorrelación Parcial (PACF)")

# ---------------------------------
# Prueba de estacionariedad (Dickey-Fuller Aumentada)
# ---------------------------------

adf_test <- adf.test(ts_temp, alternative = "stationary")

# Mostrar los resultados de la prueba
print(adf_test)

# ---------------------------------
# Transformación de la serie (diferenciación) si es necesario
# ---------------------------------

# Si la serie no es estacionaria, aplicar diferenciación
if(adf_test$p.value > 0.05) {
  ts_temp_diff <- diff(ts_temp, differences = 1)
  # Verificar estacionariedad nuevamente
  adf_test_diff <- adf.test(ts_temp_diff, alternative = "stationary")
  print(adf_test_diff)
  
  # Usar la serie diferenciada para el modelado
  ts_modeling <- ts_temp_diff
} else {
  # Usar la serie original
  ts_modeling <- ts_temp
}

# ---------------------------------
# Selección y ajuste del modelo ARIMA
# ---------------------------------

# Uso de auto.arima para seleccionar el mejor modelo ARIMA
model_arima <- auto.arima(ts_modeling, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)

# Resumen del modelo ajustado
summary(model_arima)

# ---------------------------------
# Diagnóstico del modelo
# ---------------------------------

# Verificación de los residuos
checkresiduals(model_arima)

# Prueba de Ljung-Box
ljung_box <- Box.test(residuals(model_arima), lag = 20, type = "Ljung-Box")
print(ljung_box)

# Prueba de normalidad de Shapiro-Wilk
shapiro_test <- shapiro.test(residuals(model_arima))
print(shapiro_test)

# ---------------------------------
# Validación del modelo
# ---------------------------------

# División de datos en entrenamiento y prueba
train_size <- floor(0.8 * length(ts_modeling))
train_data <- ts_modeling[1:train_size]
test_data <- ts_modeling[(train_size + 1):length(ts_modeling)]

# Ajustar el modelo con datos de entrenamiento
model_arima_train <- auto.arima(train_data, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)

# Realizar predicciones
forecast_horizon <- length(test_data)
forecast_arima <- forecast(model_arima_train, h = forecast_horizon)

# Comparar predicciones con datos reales
accuracy_measures <- accuracy(forecast_arima, test_data)
print(accuracy_measures)

# Gráfico de predicciones vs datos reales
autoplot(forecast_arima) +
  autolayer(test_data, series = "Datos Reales") +
  labs(title = "Predicciones vs Datos Reales",
       x = "Tiempo",
       y = "Temperatura Promedio (°C)") +
  theme_minimal()


# ---------------------------------
# Predicción futura
# ---------------------------------

# Reajustar el modelo con todos los datos disponibles
final_model_arima <- auto.arima(ts_modeling, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)

# Realizar predicciones futuras (por ejemplo, para los próximos 365 días)
forecast_future <- forecast(final_model_arima, h = 365)

# Visualización de las predicciones
autoplot(forecast_future) +
  labs(title = "Predicción de la Temperatura Promedio Diaria",
       x = "Tiempo",
       y = "Temperatura Promedio (°C)") +
  theme_minimal()

# ---------------------------------
# Guardado de resultados y modelos
# ---------------------------------

# Guardar el modelo ajustado
saveRDS(final_model_arima, file = "modelo_arima_cayalti.rds")

# Exportar las predicciones a un archivo CSV
predicciones <- data.frame(Fecha = seq.Date(from = max(data$Fecha) + 1, by = "day", length.out = 365),
                           Prediccion = forecast_future$mean)
write.csv(predicciones, file = "predicciones_temperatura.csv", row.names = FALSE)
