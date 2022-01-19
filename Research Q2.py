#Importing some important libraries
import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt 
import seaborn as sns 

#Reading the csv file into the program
listings = pd.read_csv('/users/maggie/Desktop/MagCleaned.csv',low_memory=False)

#Keeping uselful variables and dropping unwanted ones
keep_features = [
        'id',
        'amenities', 'price.x','neigbourhood_group', 'count',
    ]

drop_features = [i for i in listings.columns if i not in keep_features]

t3 = listings.copy()
t3.drop(drop_features, axis=1, inplace=True)
listings = t3.copy()

print("________________________________________________________")
print()
print("The remaining variable:")
print(sorted(listings.columns))
print(listings.head(5))

#Exploring the statistics of price
print("The basic statistics of price:")
print(listings ['price.x'].describe())

print("The basic statistics of count:")
print(listings['count'].describe())

#Some data exploration
print("Initial data exploration:")
print(listings.head(10))
print("The number of observation:", len(listings))
print()
print("The list of variables:")
print(listings.dtypes)
print()
print("The list of missing values:")
print(listings.isnull().sum())


#Mapping out the correlation between variables amenities, price and review scores using heatmap
corr = listings.corr(method='pearson')
plt.figure(figsize=(15,8))
sns.heatmap(corr, annot=True, vmin=-1, vmax=1, center= 0, cmap= 'coolwarm')
listings.columns
plt.title("Pearson's Correlation Plot Heatmap")
plt.show(sns.heatmap)

#Finding out the top amenities listed by owners
_names_=[]
for amenities in listings.amenities:
    _names_.append(amenities)
def split_name(amenities):
    spl=str(amenities).split(",")
    return spl
_names_for_count_=[]
for x in _names_:
    for word in split_name(x):
        word=word.lower()
        _names_for_count_.append(word)
from collections import Counter #import the counter to count the number words
_top_10_w=Counter(_names_for_count_).most_common()
_top_10_w=_top_10_w[0:10]
sub_w=pd.DataFrame(_top_10_w)
sub_w.rename(columns={0:'Words', 1:'Count'}, inplace=True)
viz_5=sns.barplot(x='Words', y='Count', data=sub_w)
viz_5.set_title('Top 10 most popular Amenities in New York Airbnb')
viz_5.set_ylabel('Number of Amenities')
viz_5.set_xlabel('Amenities')
viz_5.set_xticklabels(viz_5.get_xticklabels(), rotation=80)
plt.show(sns.barplot)



