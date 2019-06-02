
# coding: utf-8

# In[8]:



# coding: utf-8

# In[21]:


import pandas as pd
import re
from sklearn.preprocessing import StandardScaler
import numpy as np
from sklearn.decomposition import PCA

import matplotlib.pyplot as plt

# load dataset into Pandas DataFrame
df = pd.read_csv(r"C:\Users\Leonard Teng\Desktop\WQD 7005\Assignment\Assignment 3\ss.csv")

print(df)

#show dimension of data
print(df.shape)
print(df.head())


# In[14]:


x_y = ['price','volume', 'Revenue 1', 'P&L 1','EPS 1','Revenue 2','P&L 2','EPS 2','Revenue 3','P&L 3','EPS 3','Revenue 4'
            ,'P&L 4','EPS 4']
features = ['volume', 'Revenue 1', 'P&L 1','EPS 1','Revenue 2','P&L 2','EPS 2','Revenue 3','P&L 3','EPS 3','Revenue 4'
            ,'P&L 4','EPS 4']
# Separating out the features
#x = df.loc[:, features].values
# Separating out the target and replace nan with zero values

for nf in features:
    rows = []
    for element in df[nf]:
        try:
            if type(element) == str:
                element = re.sub(r'[^\w\s]','',element)
            element = float(element)
        except ValueError:
            #print("error",e," happens!")
            element = 0
        rows.append(element)
    df[nf] = rows
# Standardizing the features
y = df.loc[:,['price']].replace(np.nan,0).values
x = df.loc[:, features].replace(np.nan,0).values
x = StandardScaler().fit_transform(x)
print (x)
print (y)
x = pd.DataFrame(x,columns = features)
y = pd.DataFrame(x, columns = ['price'])


# In[15]:


pca = PCA(n_components=2)
principalComponents = pca.fit_transform(x)
principalDf = pd.DataFrame(data = principalComponents
             , columns = ['principal component 1', 'principal component 2'])

print(principalDf)

finalDf = pd.concat([principalDf, df[['price']]], axis = 1)

print(finalDf)


# In[33]:


explained_variance = pca.explained_variance_ratio_  
print(explained_variance)

fig = plt.figure(figsize = (8,8))
ax = fig.add_subplot(1,1,1)
ax.set_xlabel('Principal Component 1', fontsize = 15)
ax.set_ylabel('Principal Component 2', fontsize = 15)
ax.set_title('2 component PCA', fontsize = 20)
ax.scatter(finalDf.loc[:,'principal component 1'],
           finalDf.loc[:,'principal component 2'])
ax.grid()
plt.show()


# In[106]:


# co_variance_list = []
# for vf in features:
#     variable = x[vf].as_matrix().reshape(len(x[vf]),1)
#     co_variance = np.cov(variable, y)
#     co_variance_list.append(co_variance[0,1])

# print(co_variance_list)

#for vf in features:
 #   variable = x.loc[:,vf]
 #  print (variable)

# variable = x.loc[:,'volume'].as_matrix().reshape(len(x['volume']),1)
# y = y.as_matrix().reshape(len(y),1)
# print (type(variable))
# print(type(y))
# print(variable.shape, y.shape)
# co_variance = np.cov(variable, y)
# print (co_variance)

# finalDf = pd.concat([x, y], axis = 1)
cov_value = df.loc[:, x_y].replace(np.nan,0).values
cov_value = StandardScaler().fit_transform(cov_value)
cov_value = pd.DataFrame(cov_value,columns = x_y)
print(cov_value)
co_variance_matrix = cov_value.cov()


# In[110]:



print(co_variance_matrix)
print(co_variance_matrix.loc[:,['price']].sort_values('price', ascending=False))
