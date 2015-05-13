八皇后问题的递归实现（mips asm）
=================
在8×8的国际象棋棋盘上放置8个皇后,要求任意两个皇后不能
在同一行、同一列或同一条对角线上。求出如此放置方法的种数。

***对应C代码如下***
---------
```c
    #include <stdio.h >
    #include <math.h >
    int Site[8];
    int Queen( int n, int QUEENS, int );
    
    
    int Valid( int n );
    
    
    void main()
    {
    	int	m;
    	int	iCount = 0;
    	int	n;
    	printf( "Eight Queen problems, entering the number of queens:" );
    	scanf( "%d", &n );
    	m = Queen( 0, n, iCount );
    	printf( "%d\n", m ); return;
    }
    
    
    /*-----------------Queen:递归放置第n 个皇后---------------*/
    int Queen( int n, int QUEENS, int iCount )
    {
    	int i;
    	if ( n == QUEENS )
    	{
    		iCount = iCount + 1;
    		return(iCount);
    	}
    	for ( i = 1; i <= QUEENS; i++ )
    	{
    		Site[n] = i;
    /*---------------Valid:判断放置第n 个皇后时是否无冲突---------------*/
    		if ( Valid( n ) )
    			iCount = Queen( n + 1, QUEENS, iCount );
    	}
    	return(iCount);
    }
    
    
    /*------Valid:判断第n 个皇后放上去之后,是否合法,即是否无冲突。------*/
    int Valid( int n )
    {
    	int i;
    	for ( i = 0; i < n; i++ )
    	{
    		if ( Site[i] == Site[n] )
    			return(0);
    		if ( abs( Site[i] - Site[n] ) == (n - i) )
    			return(0);
    	}
    	return(1);
    }
```
