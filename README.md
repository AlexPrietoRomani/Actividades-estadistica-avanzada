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