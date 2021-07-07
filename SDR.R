library(readxl)
train = read_excel('train.xlsx')
test = read_excel('test.xlsx')
all = rbind(train,test)

# PSVM
# Step 0: standardization
library(data.table)
all = as.data.table(all[,2:ncol(all)])
features = c('3021','3022','3200','3131','3385','3268' ,'3038', '3287', '3288','3040','3078','3261','3094')
all = all[,..features]
y = all$`3094`
x = all[,1:(ncol(all)-1)]

rep.row<-function(x,n){
  matrix(rep(x,each=n),nrow=n)
}
"%^%" <- function(x, n) 
  with(eigen(x), vectors %*% (values^n * t(vectors)))

# Step 1: 
x_mean = rep.row(colMeans(x),nrow(x))
x_sigma = cov(x)

# Step 2:
library(e1071)
h=3
q_r_list = quantile(y,prob=seq(0,1,length.out = (h+2))[2:(h+2-1)])
for (i in 1:length(q_r_list)){
  print(i)
  M_n = 0
  q_r = q_r_list[i]
  y_ind_r = sign(sign(y-q_r)-0.1)
  # Step 3:
  z_r = t((x_sigma %^% (-0.5)) %*% t(as.matrix(x - x_mean)))
  test_error = c()
  for (lamb in 2^seq(-4,4,by=1)){
    test_model = svm(x=z_r[1:10000,],y=y_ind_r[1:10000],kernel="linear",C=lamb,cross=5,type = "C-classification")
    test_error = c(test_error,mean(test_model$accuracies))
  }
  print('finish cv')
  lambda_cv = 2^seq(-4,4,by=1)[which.max(test_error)]
  model = svm(x=z_r,y=y_ind_r,kernel="linear",C=lambda_cv,type='C-classification')
  beta_r_hat = t(model$SV) %*% model$coefs
  M_n = M_n + beta_r_hat %*% t(beta_r_hat)
}

# Step 4:
order_list = c()
for (i in 1:(length(eigen(M_n)$values)-1)){
  order_list = c(order_list,eigen(M_n)$values[i]/eigen(M_n)$values[i+1])
}
d = which.max(order_list)
B_hat = eigen(M_n)$vectors[,1:d]

