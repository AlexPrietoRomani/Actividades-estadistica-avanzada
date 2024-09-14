# 

# Correcto: usando comillas estándar para definir la URL
www <- "https://web.archive.org/web/20120202113105/http://www.massey.ac.nz/~pscowper/ts/Maine.dat"

# Intentar con diferentes configuraciones de sep y otros parámetros
desempleo <- read.table(www, header = TRUE, sep = "", fill = TRUE, stringsAsFactors = FALSE)

attach(desempleo)
desempleo.ts <- ts(desempleo, start = c(1996, 1), freq =
12)

# Graficar
plot(desempleo.ts)

# Tendencias y Variaciones periódicas
Maine.month.ts <- ts(unemploy, start = c(1996, 1), freq =
12)

# Datos anuales - otra forma de agregar los datos
annual.ts <- aggregate(desempleo.ts)/12
plot(annual.ts)

# Tendencias y Variaciones periódicas
Maine.month.ts <- ts(unemploy, start = c(1996, 1), freq =
12)
plot(Maine.month.ts, ylab = "unemployed (%)")

Maine.Feb <- window(Maine.month.ts, start = c(1996,2), freq = TRUE)
Maine.Aug <- window(Maine.month.ts, start = c(1996,8), freq = TRUE)
Feb.ratio <- mean(Maine.Feb) / mean(Maine.month.ts)
Aug.ratio <- mean(Maine.Aug) / mean(Maine.month.ts)

Feb.ratio
Aug.ratio

desempleo1 <- window(annual.ts, start = c(1996, 1), end = c(2000, 1))
desempleo2 <- window(annual.ts, start = c(2000, 1), end = c(2005, 1))
layout (1:2)
plot(desempleo1)
plot(desempleo2)

# El promedio anual
annual.mean <- aggregate(desempleo.ts, FUN = mean) 
plot(annual.mean)

# Descomposición de Series Temporales
Tendencia (trend, T)
Estacional (seasonal, S)
Cíclico (cyclic, C)
Ruido (remainder, R)

