#include<stdio.h>
#define M 2
#define N 3
#define P 3
#define Q 1

int get_element_from_matrix(int* matrix[], int n, int row, int col);
int inner_prod(int* mat_a[], int* mat_b[], unsigned int row_a, unsigned int col_b, unsigned int max_col_a, unsigned int max_col_b);
int matrix_multiplication(int* res[], int* mat_a[], int* mat_b[], unsigned int m, unsigned int n, unsigned int p, unsigned int q);

/* Auxilarry function to print the result. Use it to test yourselves. */
void print_result_matrix(int* matrix, unsigned int m, unsigned int n) {
    printf("[");
    for(int i=0; i<m; i++) {
        for(int j=0; j<n; j++) {
            if (j==n-1) printf("%d", *(matrix + i*n + j));
            else printf("%d ", *(matrix + i*n + j));
        }
        if (i<m-1) printf("\n");
    }
    printf("]\n");
}
void set_element_in_matrix(int* matrix[], unsigned int num_of_columns,unsigned int row, unsigned int col, int value){
    ((int*)matrix)[num_of_columns*row+col]=value;
}
int get_element_from_matrix(int* matrix[], int n, int row, int col){
    return ((int*)matrix)[n*row+col];

}
int inner_prod(int* mat_a[], int* mat_b[], unsigned int row_a, unsigned int col_b, unsigned int max_col_a, unsigned int max_col_b){
    int sum=0;
    int temp1;
    for (int i=0; i< max_col_a;i++){
        temp1= get_element_from_matrix(mat_a,max_col_a,row_a,i);
        sum+=temp1* get_element_from_matrix(mat_b,max_col_b,i,col_b);
    }
    return sum;
}

int matrix_multiplication(int* res[], int* mat_a[], int* mat_b[], unsigned int m, unsigned int n, unsigned int p, unsigned int q){
    if (n!=p){
        return 0;
    }
    int value;
    for (int i=0; i<m; i++){
        for(int j=0; j<q;j++){
            value=inner_prod(mat_a,mat_b, i,j,n,q);
            set_element_in_matrix(res,q,i,j,value);
        }
    }
    return 1;
}



int main() {
    int mat_a[M][N] = { {1,0,3}, {0,1,2} };
    int mat_b[P][Q] = { {0}, {15}, {3} };
    int res[M][Q];
    printf("mat_a[0][2] = %d\n", get_element_from_matrix((int**)mat_a, 3, 0, 2));
    printf("mat_a[1]*mat_b[0] = %d\n", inner_prod((int**)mat_a, (int**)mat_b, 1, 0, 3, 1));
    matrix_multiplication((int**)res, (int**)mat_a, (int**)mat_b, M, N, P, Q);
    printf("mat_a*mat_b=\n");
    print_result_matrix((int*)res, M, Q);
    return 0;
}
