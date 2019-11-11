1. 查看了BM算法的详细实现过程，参考[苯苯吹雪的BM算法详解](https://www.cnblogs.com/xubenben/p/3359364.html)的解释，将自己理解注释一下代码。

```
#include <cstring>
#include <iostream>

#define XSIZE 4
#define ASIZE 256
#define MAX(x, y) (x) > (y) ? (x) : (y)

using namespace std;

/*
 *bmBc[k]表示坏字符k在模式串中出现的位置距离模式串末尾的最大长度。
 *假设所有字符没有出现在模式串中，默认长度为模式串长度m
 *注意：！！！如果模式串中有重复出现的字符，坏字符表的值是最右边出现位置的值，也就是bmBc[k]最小的值。如果匹配时，坏字符是这个字符，如果i正好是这个字符两次出现的中间位置，这是如果用肉眼看坏字符移动应该是移动模式串让左边的字符匹配到i处的坏字符，但bmBc[k]是右边的k距离末尾的距离。这是不会出错是因为b[k]-(m-1-i)的值一定是一个负值。而i匹配到了模式串中间的位置，这时一定有好后缀，好后缀确定的移动距离一定不是负值，所以这是移动的距离是由好后缀确定的，所以bmBc[k]才可以保存最右边的字符距离末尾的值。
 *
 * */
void preBmBc(const char *x, int m, int bmBc[]) {
	int i;
	for (i = 0; i < ASIZE; ++i) 
	  bmBc[i] = m;
	for (i = 0; i< m - 1; ++i){
	  bmBc[x[i]] = m - i -1;
	}
}

/*
 *suffix数组表示以i为边界，与模式串后缀匹配的最大长度，
 *用公式描述：满足P[i-s, i] == P[m-s, m]
 *如果i不等于m，suffixs[i] 肯定是0，第一个字母都不等。
 * */
void suffixs(const char *x, int m, int *suff) {
	int i, q;	
	suff[m-1] = m; //模式串末尾的前缀是整个模式串
	for (i = m -2; i >= 0; --i) {
		q = i;  //需要两个索引分别表示前缀和后缀的比较的位置
		//这里之所以 +q是用了q在逐渐减小1， 用另外的变量减一也可以。
		while (q >= 0 && x[q] == x[m - 1 - i + q]) 
		  --q;
		suff[i] = i - q;
	}
	
}
/*
 *bmGs[i] 表示遇到好后缀时，模式串应该移动的距离，i表示好后缀前面一个字符的位置
 *bmGs数组分三种情况：
 *1. 模式串有子串匹配上好后缀
 *2. 模式串没有子串匹配上好后缀，但找到一个最大前缀
 *3. 模式串中没有匹配上好后缀，同时也没有最大前缀和好后缀匹配
 * */
void preBmGs(const char *x, int m, int bmGs[]) {
	int i, j, suff[XSIZE];
	suffixs(x, m, suff);
	for (i = 0; i < m; ++i) //没有匹配上子串没有好后缀，移动m
	  bmGs[i] = m;
	j = 0;
	for (i = m - 1; i >= 0; --i) 
		/*
		 *前缀匹配
		 *如果一个字符的最长后缀匹配列长是i+1，
		 *说明匹配到了首字母位置，是好后缀的匹配前缀。
		 *如果i = m - 1,前缀匹配到了后缀，说明完全匹配，搜索结束
		 * */
		if (suff[i] == i + 1) 
		  for(; j < m -1 - i; ++j) //前缀长度i+1，后缀的长度肯定大于 i + 1
			/*
			 * 注意：！！！这里好后缀移动长度从后往前写是因为没有完全匹配最长好后缀的情况下，取匹配好后缀的的最长前缀，这样字符串往后移动最小，这时bmGs[0:i]的移动长度都应该是匹配到最长前缀时移动的长度，前边的bmGS[0:i-1]虽然也可能是匹配到了好后缀(后缀是重复字节的情况)，但是他移动的长度过大，错过了几个完全匹配的字符。可能错过匹配。所以，bmGs在匹配到了最长前缀后，只可以更改一次，否则会错过匹配。
			 * */
			if (bmGs[j] == m)
				bmGs[j] = m - 1 - i; 
	for (i = 0; i <= m - 2; ++i) 
	  bmGs[m - 1 - suff[i]] = m - 1 -i;
		/*
		 * 注意：这里当一个字符的suff[i]是0是，计算的是好后缀个数为0时匹配的前缀移动的长度。就是当最末尾一个字符都不等。这时查找的就是suff[i]等于0，即本身和m-1都不等的字符移动到m-1的长度(如果字符和m-1相等，suff[i] >=1)。这时要匹配最右侧一个和m-1不同的值。bmGs[m-1]表示就是m-1没有匹配时的好后缀，这是找最右侧和m-1不同的值就可以了，就是suff[i]==0的字符。i从小到大，bmGs[m-1]最终回去最小的和自己不同的字符位置。
		 * */
}		

void BM(const char *x, int m, const char *y, int n) {
	int i, j, bmGs[XSIZE], bmBc[ASIZE];

	preBmGs(x, m, bmGs);
	preBmBc(x, m, bmBc);

	j = 0;
	while (j <= n - m) {
		for (i = m -1; i >= 0 && x[i] == y[i + j]; --i);
		if (i < 0) {

		  std::cout << "successful" << std::endl;
		  std::cout << j << std::endl;
		  j += bmGs[0];
		  //这里用了如果p[0]不等时的最大好后缀移动长度。加一也可以。
		}
		else {
		  int a = bmGs[i];
		  int b = bmBc[y[i+j]] - m + 1 + i;
		  int c = bmBc[y[i+j]];
		  j += MAX(bmGs[i], bmBc[y[i + j]] - m + 1 + i);
		}

	}
}

int main()
{
	const char *x = "abab";
	const char *y = "ababab";
	BM(x, strlen(x), y, strlen(y));
}

```
