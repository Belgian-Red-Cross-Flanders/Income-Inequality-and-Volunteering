# Income Inequality and Volunteering: Divergent Patterns Across Country Income Levels
#### Jakub Dostál (1), Kelsey J. MacKay (2,3), Fritz Schiltz (2), Philippe Vandekerckhove (2,3,4)

1: Department of Economic Studies, College of Polytechnics Jihlava, Jihlava, Czech Republic; corresponding author: jakub.dostal@vspj.cz

2: Centre for Empirical Research on the Third Sector, Belgian Red Cross-Flanders, Mechelen, Belgium

3: Department of Public Health and Primary Care, Leuven Institute for Healthcare Policy, KU Leuven, Leuven, Belgium

4: Division of Epidemiology and Biostatistics, Department of Global Health, Faculty of Medicine and Health Sciences, Stellenbosch University, Stellenbosch, South Africa

# Summary
This article examines the relationship between income inequality and volunteering across 111 countries using the Johns Hopkins Third Sector Dataset and World Bank data. While prior research in European contexts suggests that higher inequality is associated with lower volunteering, our global analysis reveals a structurally conditional pattern. In upper-middle- and high-income countries, greater income inequality is linked to lower levels of volunteering. In contrast, in low- and lower-middle-income countries, the association reverses direction, suggesting distinct contextual dynamics. The findings challenge universal assumptions about the inequality–volunteering relationship and highlight the importance of embedding volunteering research within broader structural and economic conditions. Implications are discussed for both scholarship and policy within the framework of Sustainable Development Goal 10.

# [Import Data](https://github.com/Belgian-Red-Cross-Flanders/Income-Inequality-and-Volunteering/tree/main/data_raw)

Using the data_raw folder, three excel files can be downloaded: 

Volunteer Hours and Gini Coefficient 
Download [Red Cross Gini volunteering research.xlsx]

Palma Ratio 
Download [palma-ratio.xlsx]

Income Share of Richest 1% of Population
Download [Richest_1.xlsx]

# [Scripts](https://github.com/Belgian-Red-Cross-Flanders/Income-Inequality-and-Volunteering/tree/main/scripts)

The folder of scripts uses the following structure: 
  
  [01_load packages.R](https://github.com/Belgian-Red-Cross-Flanders/Income-Inequality-and-Volunteering/blob/main/scripts/01_load_packages.R)
  
  [02_functions.R](https://github.com/Belgian-Red-Cross-Flanders/Income-Inequality-and-Volunteering/blob/main/scripts/02_functions.R)
  
  [03_import_data.R](https://github.com/Belgian-Red-Cross-Flanders/Income-Inequality-and-Volunteering/blob/main/scripts/03_import_data.R)
  
  [04_clean_merge](https://github.com/Belgian-Red-Cross-Flanders/Income-Inequality-and-Volunteering/blob/main/scripts/04_clean_merge.R) Note: this creates the data_clean folder, in which the master_dataset.xlsx is created 
  
  [05_descriptives](https://github.com/Belgian-Red-Cross-Flanders/Income-Inequality-and-Volunteering/blob/main/scripts/05_descriptives.R) Note: this creates the descriptives folder in the outputs folder 
  
  [06_correlations](https://github.com/Belgian-Red-Cross-Flanders/Income-Inequality-and-Volunteering/blob/main/scripts/06_correlations.R) Note: this creates the correlations folder in the outputs folder 
  
  [07_figures.R](https://github.com/Belgian-Red-Cross-Flanders/Income-Inequality-and-Volunteering/blob/main/scripts/07_figures.R) Note: this creates the figures folder in the outputs folder 








