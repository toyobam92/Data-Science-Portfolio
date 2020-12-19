The one-stop PCA center:

What are Eigenfaces and how does it relates to dimnsionality reduction?
    Eigenfaces represents the set of eigenvectors of the covariance matrix of facial images, the essence of this approach is to capture the direction with the most variance and transform the original face images while preserving the most information.
    PCA enables dimensionality reduction which is the first step in this process whereby eigenvectors are obtained to produce principal components that represent the original training images. The overall idea is to go from a d-dimensional dataset by projecting it onto a (k)-dimensional subspace (where k<d) in order to increase the computational efficiency while retaining most of the information.
    Eigen Faces Classification steps
  
For the purpose of this project, the demo data set consists of 5 classes of 10 images of various individuals for eigenfaces based classification.
    1. Import 50 png images using the upload button in Rshiny
    2. Convert each image to a long vector and combine in a matrix
    3. Separate images into training and test set (80/20 split)
    4. Perform Principal component analysis(PCA) on training set (40 images)
    a. Compute the mean face vector u
    b. Subtract the mean face from each face vector to normalize the training set
    c. Compute the covariance matrix
    i. C = A'* A
    d. Extract the eigenvectors and eigenvalues
    e. Calculate the eigenfaces by multiplying the eigenvectors by normalized training matrix
    f. Choose the most significant eigenfaces capture 95%(or any choice) to produce transformed data
    g. Calculate the weights: each normalized training images multiplies each eigenface
    h. Vectorize and normalize the test images and calculate the weights
    i. Define the distance within the face space between the training images and test images for a simple classification by using Euclidian distance
