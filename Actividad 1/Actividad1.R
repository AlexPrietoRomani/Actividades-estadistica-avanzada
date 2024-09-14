# -------------------- Carga de datos
# Instalar la librería
install.packages("dplyr")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("GGally")
install.packages("knitr")

# Cargar las librerías necesarias
library(ggplot2)
library(dplyr)
library(lubridate)
library(GGally)
library(knitr)

# Especificar el nombre del archivo Excel
nombre_archivo <- "Actividad 1/Data Consumo Electrico.csv"

# Construir la ruta completa al archivo
ruta_completa <- file.path(getwd(), nombre_archivo)

# Cargar los datos
data <- read.csv(ruta_completa, sep = ",", header = TRUE)

# Visualizar los datos
str(data)

# Visualizar los datos
head(data)

# ---------------------- Procesamiento de datos
# Convertir 'FechaCorte' a formato fecha (aaaammdd)
data$FechaCorte <- as.Date(as.character(data$FechaCorte), format = "%Y%m%d")

# Convertir 'FechaInicio' al formato fecha y tiempo adecuado ("dd/mm/yyyy HH:MM")
data$FechaInicio <- as.POSIXct(data$FechaInicio, format = "%d/%m/%Y %H:%M")

# Calcular los días de consumo como la diferencia entre 'FechaCorte' y 'FechaInicio'
data$DiasConsumo <- as.numeric(difftime(data$FechaCorte, data$FechaInicio, units = "days"))

# Visualizar los datos
head(data)

# Eliminar las columnas 'FechaInicio' y 'FechaCorte'
data <- data %>% select(-FechaInicio, -FechaCorte)

# Convertir 'Periodo' a formato año-mes (aaaamm) y separar en columnas 'Año' y 'Mes'
data$Periodo <- as.character(data$Periodo)
data$Año <- as.numeric(substr(data$Periodo, 1, 4))
data$Mes <- as.numeric(substr(data$Periodo, 5, 6))

# Eliminar la columna 'Periodo'
data <- data %>% select(-Periodo)

# Mostrar el resultado
head(data)

# Mostrar estadisticas de cada columna
summary(data)

## ---------------------------- Verificación de Outliers
#Función para detectar outliers fuertes
detectar_y_eliminar_outliers <- function(df, columnas, eliminar = FALSE, coincidencia = "all") {
  # Crear una lista para almacenar los índices de los outliers por columna
  outliers_indices <- list()
  
  # Iterar sobre las columnas especificadas
  for (column_name in columnas) {
    # Extraer los datos de la columna
    column_data <- df[[column_name]]
    
    # Calcular Q1, Q3 e IQR
    Q1 <- quantile(column_data, 0.25, na.rm = TRUE)
    Q3 <- quantile(column_data, 0.75, na.rm = TRUE)
    IQR <- Q3 - Q1
    
    # Definir los límites para los outliers
    lower_bound <- Q1 - 1.5 * IQR
    upper_bound <- Q3 + 1.5 * IQR
    
    # Detectar índices de outliers
    outliers <- which(column_data < lower_bound | column_data > upper_bound)
    
    # Guardar los índices de outliers en la lista
    outliers_indices[[column_name]] <- outliers
    
    # Imprimir la cantidad de outliers detectados en la columna
    print(paste("La columna", column_name, "tiene", length(outliers), "outliers."))
  }
  
  # Convertir la lista de índices de outliers en una matriz lógica
  filas_outliers_logicas <- sapply(outliers_indices, function(x) {
    filas <- rep(FALSE, nrow(df))
    filas[x] <- TRUE
    return(filas)
  })
  
  # Determinar las filas a eliminar según el argumento 'coincidencia'
  if (coincidencia == "all") {
    # Eliminar filas donde todas las columnas tienen outliers (intersección)
    filas_outliers <- which(rowSums(filas_outliers_logicas) == length(columnas))
    
  } else if (coincidencia == "any") {
    # Eliminar filas donde al menos una columna tiene un outlier (unión)
    filas_outliers <- which(rowSums(filas_outliers_logicas) > 0)
    
  } else if (coincidencia == "majority") {
    # Eliminar filas donde más del 50% de las columnas tienen outliers
    filas_outliers <- which(rowSums(filas_outliers_logicas) > length(columnas) / 2)
    
  } else {
    stop("El valor de 'coincidencia' debe ser 'all', 'any' o 'majority'.")
  }

  # Imprimir la cantidad de filas con outliers según el criterio de coincidencia
  print(paste("Hay", length(filas_outliers), "filas con outliers según el criterio de coincidencia:", coincidencia, "."))
  
  if (eliminar) {
    # Eliminar las filas que coinciden según el criterio de 'coincidencia'
    df_sin_outliers <- df[-filas_outliers, ]
    
    # Imprimir las filas que serán eliminadas
    print(paste("Se eliminarán", length(filas_outliers), "filas según el criterio de coincidencia:", coincidencia))
    
    return(df_sin_outliers)  # Retornar el data frame sin las filas con outliers
  } else {
    # Solo retornar los índices de las filas con outliers sin eliminar
    return(filas_outliers)  # Retornar los índices de las filas con outliers
  }
}

# Utilizando detección de outliers para el dataframe
outliers_detectados <- detectar_y_eliminar_outliers(data,c("ConsumoKwh", "Energia_Soles", "DiasConsumo"), 
                                                    eliminar = FALSE, coincidencia = "any")
print(outliers_detectados)

# Verificar dimensiones del dataframe
dim(data)

#Función para eliminar outliers
data_sin_outliers <- detectar_y_eliminar_outliers(data,c("ConsumoKwh", "Energia_Soles", "DiasConsumo"), 
                                                  eliminar = TRUE, coincidencia = "any")

# Verificar dimensiones del dataframe
dim(data_sin_outliers)

## ---------------------------- GRaficos de cajas de Outliers
ggplot(data_sin_outliers, aes(x = factor(1), y = DiasConsumo)) +
        geom_boxplot(fill = "skyblue", color = "darkblue") +
        labs(title = "Gráfico de Cajas para DiasConsumo",
             x = "",
             y = "DiasConsumo") +
        theme_minimal() +
        theme(axis.text.x = element_blank(), axis.ticks.x = element_blank()) # Remueve las etiquetas del eje x

ggplot(data_sin_outliers, aes(x = factor(1), y = Energia_Soles)) +
  geom_boxplot(fill = "skyblue", color = "darkblue") +
  labs(title = "Gráfico de Cajas para Energia_Soles",
        x = "",
        y = "Energia_Soles") +
  theme_minimal() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank()) # Remueve las etiquetas del eje x

ggplot(data_sin_outliers, aes(x = factor(1), y = ConsumoKwh)) +
  geom_boxplot(fill = "skyblue", color = "darkblue") +
  labs(title = "Gráfico de Cajas para ConsumoKwh",
        x = "",
        y = "ConsumoKwh") +
  theme_minimal() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank()) # Remueve las etiquetas del eje x

## ---------------------------- Graficos de correlación
# Seleccionar solo las columnas numéricas del data frame
df_numeric <- data_sin_outliers[, c("ConsumoKwh", "Energia_Soles", "DiasConsumo")]

# Generar el gráfico de correlación de Pearson usando ggpairs()
ggpairs(
  df_numeric,
  lower = list(continuous = wrap("points", alpha = 0.3, size = 0.5)),  # Gráficos de dispersión para las correlaciones
  upper = list(continuous = wrap("cor", size = 4)),                    # Coeficiente de correlación de Pearson
  diag = list(continuous = wrap("densityDiag", alpha = 0.5)),          # Densidad para la diagonal
  title = "Matriz de Correlación de Pearson"
)

## ---------------------------- Matriz de correlación
# Calcular la matriz de correlación de Pearson
correlation_matrix <- cor(df_numeric, use = "complete.obs", method = "pearson")

# Mostrar la matriz de correlación en una tabla usando kable
kable(correlation_matrix, caption = "Matriz de Correlación de Pearson para Columnas Seleccionadas")

# --------------------- Regresión linal Simple
# Regresión lineal simple: ConsumoKwh vs Energia_Soles
modelo_lineal_simple <- lm(Energia_Soles ~ ConsumoKwh, data = data_sin_outliers)

# Resumen del modelo
summary(modelo_lineal_simple)

# Visualización del modelo
ggplot(data, aes(x = ConsumoKwh, y = Energia_Soles)) +
  geom_point() +
  geom_smooth(method = "lm", col = "blue") +
  labs(title = "Regresión Lineal Simple: Consumo vs Costo",
       x = "Consumo (Kwh)",
       y = "Costo (S/.)")

# Grafico 1 (Residuos vs Fitted)
# Esté gráfico nos muestra si los residuos tienen patrones no lineales.
plot(modelo_lineal_simple ,which = 1)

# Gráfico 2 (Normal Q-Q)
# Este gráfico nos muestra si los residuos se distribuyen normalmente.
plot(modelo_lineal_simple ,which = 2)

# Gráfico 3 (Scale - Location)
# Este gráfico muestra si los residuos se distribuyen por igual a lo largo
# de los rangos de predictores. Así se puede verificar el supuesto de la 
# varianza constante (homocedasticidad).
plot(modelo_lineal_simple ,which = 3)

# Gráfico 4 (Residuos vs Leverage)
# Nos ayuda a encvontrar observaciones influyentes (si las hay).
# No todos los valores atípicos influyen en el análisis de regresión lineal.
plot(modelo_lineal_simple ,which = 4)

# Influencia (Leverage): estima la contribución de cada obsevación a la predicción.
# Discrepancia: Asociada a los residuos
plot(modelo_lineal_simple ,which = 5)

# Análsis de los residuos
plot(fitted((modelo_lineal_simple), res))
abline(0,0)

# Estimación de los intervalos de confianza
confint(modelo_lineal_simple, level = 0.99)

# --------------------- Regresión linal múltiple
# Ajustar el modelo de regresión lineal múltiple
modelo_lineal_multiple <- lm(Energia_Soles ~ ConsumoKwh + Tarifa + DiasConsumo, data = data_sin_outliers)

# Resumen del modelo
summary(modelo_lineal_multiple)

# Obtener los valores predichos por el modelo
predicciones <- predict(modelo_lineal_multiple, data_sin_outliers)

# Crear un data frame para el gráfico con valores reales y predichos
graficos_data <- data.frame(Valor_Real = data_sin_outliers$Energia_Soles, Valor_Predicho = predicciones)

# Graficar predicciones vs valores reales
ggplot(graficos_data, aes(x = Valor_Real, y = Valor_Predicho)) +
  geom_point(color = "blue", alpha = 0.4) +  # Puntos de dispersión
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +  # Línea de referencia (x = y)
  labs(title = "Gráfico de Regresión Lineal Múltiple: Predicciones vs Valores Reales",
       x = "Valores Reales (Energia_Soles)",
       y = "Valores Predichos (Energia_Soles)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))  # Centrar el título

# --------------------- Regresión linal Polinómica
# Ajustar el modelo de regresión polinómica (grado 2) para ConsumoKwh
modelo_polinomico <- lm(Energia_Soles ~ poly(ConsumoKwh, 2) + Tarifa + DiasConsumo, data = data_sin_outliers)

# Resumen del modelo
summary(modelo_polinomico)

# Obtener los valores predichos por el modelo polinómico
predicciones_polinomico <- predict(modelo_polinomico, data_sin_outliers)

# Crear un data frame para el gráfico con valores reales y predichos
graficos_data_polinomico <- data.frame(Valor_Real = data_sin_outliers$Energia_Soles, 
                                       Valor_Predicho = predicciones_polinomico,
                                       ConsumoKwh = data_sin_outliers$ConsumoKwh)

# Graficar la relación ajustada con el modelo polinómico
ggplot(graficos_data_polinomico, aes(x = ConsumoKwh, y = Valor_Real)) +
  geom_point(color = "blue", alpha = 0.4) +  # Puntos de dispersión de los valores reales
  geom_line(aes(y = Valor_Predicho), color = "red", linewidth = 1) +  # Línea ajustada del modelo polinómico
  labs(title = "Gráfico de Regresión Polinómica: ConsumoKwh vs Energia_Soles",
       x = "ConsumoKwh",
       y = "Energia_Soles") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))  # Centrar el título
