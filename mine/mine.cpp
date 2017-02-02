#include <iostream>
#include <cstdio>
#include <cstring>
using namespace std;

int word[10000];
int len;

struct handle {
	int generator;
	int pos1;
	int pos2;
};

int abs (int n) { return n > 0 ? n : -n; }

int getMinGen() {
  int minGen = abs(word[0]);
  for (int i = 1; i < len; i++)
    if (abs(word[i]) < minGen)
      minGen = abs(word[i]);
  return minGen;
}

int getStrands() {
  int maxGen = abs(word[0]);
  for (int i = 1; i < len; i++)
    if (abs(word[i]) > maxGen)
      maxGen = abs(word[i]);
  return maxGen + 1;
}

// assumes word has been reduced
bool isSigmaPos() {
  int minGen = getMinGen();
  for (int i = 0; i < len; i++)
    if (word[i] == -minGen)
      return false;
  return true;
}

void FreeReduction( ) {
	int r, l;
	int Wl;

	for( l= -1, Wl=0, r=0; r < len; r++ ) {
		if( Wl == (-1)*word[r] ) {
			word[l] = word[r] = 0;
			l--;
			Wl = ( l < 0 ? 0 : word[l] );
		} else {
			l++;
			if( l != r ) {
				word[l] = word[r];
				word[r] = 0;
			}
			Wl = word[l];
		}
	}
	len = l+1;
}

int FindGenerator (int gen, int start, int end) {
	for (int i = start; i < end; i++)
		if (abs(word[i]) == gen)
			return i;
	return -1;
}

handle FindHandle( int Gen, int L1, int L2 ) {
	int h1, h2; /* this are positions the handle, that we find */
	handle H;
	h1 = FindGenerator( Gen, L1, L2 );
	if( h1 == -1 || h1 == L2 - 1) {
		H.generator = 0;
		return H;
	}

	while( ( h2 = FindGenerator( Gen, h1 + 1, L2 ) ) != -1) {
		if( word[h1] == word[h2])
			h1 = h2;
		else {
			H.generator = Gen;
			H.pos1 = h1;
			H.pos2 = h2;
			return H;
		}
	}
	H.generator = 0;
	return H;
}

int HandleTransform( handle H ) {
	int i,  e = word[H.pos1]/abs( word[H.pos1] );
	int Length1, c = 0;
	int Temp[1000];


	for( i = H.pos1 + 1; i < H.pos2; i++ ) {
		if( i + c + 1 < 1001) {
			if( abs( word[i] ) != H.generator + 1 )
				Temp[i + 2*c - 1] = word[i];
			else {
				Temp[i + 2*c - 1] = (-1) * e * (H.generator + 1);
				Temp[i + 2*c] = word[i]/abs(word[i])*H.generator;
				Temp[i + 2*c + 1] = e*(H.generator + 1);
				c++;
			}
		} else
			return 1000;

	}

	memmove( word + H.pos2 + 2*c-1,
			 word + H.pos2 + 1,
			 (len - 1 - H.pos2) * sizeof(int) );

	memmove( word + H.pos1,
			 Temp + H.pos1,
			 (H.pos2 + 2*c - 1 - H.pos1) * sizeof(int) );

	len = len + 2*c - 2;
	if( len > 1000 ) {
		printf( "No memory" );
		return 1000;
	}
	Length1 = len;

	FreeReduction();

	return 2 *c - 2 - ( Length1 - len);
}

/* Returns the the difference of old and new lenghts of the Word */
int HandleReduction( handle H ) {
	handle H1;
	int Pos2Change = 0, k, HTr;
	while( 1 ) {
		H1 = FindHandle( H.generator + 1, H.pos1 + 1, H.pos2 );
		if( H1.generator == 0 ) {
			if( ( HTr = HandleTransform( H ) ) == 1000 ) {
				printf( "No memory" );
				return 1000;
			}
			return Pos2Change + HTr;
		}
		k = HandleReduction( H1 );
		Pos2Change += k;
		H.pos2 += k;
		if ( H.pos2 < H.pos1 )
			return Pos2Change +HTr;
	}
	return 0;
}

int *Reduction( ) {
	int J;
	handle H;
	FreeReduction( );
	if( len == 0 )
		return  0;

	J = getMinGen( );
	H = FindHandle( J, 0, len );
	if( H.generator == 0 )
		return word;

	HandleReduction( H );
	Reduction( );
}

int main() {
	FILE *fp1, *fp2;
	int i = 0, j, Length1;

	fp1 = fopen( "wordin", "r" );
	if( fp1 == NULL ) {
		printf( "File doesn't exit.\n" );
		return -1;
	}
	while( fscanf( fp1, "%d", &word[i]) != EOF )
		i++;
	if( i > 1000 )  {
		printf( "NO memory" );
		return -1;
	}
	len = i - 1;
  // Length1 is length of braid word (not counting terminating 0)

  // This block is for input of the form "a 0 b"
  // I don't need this
  /*
	i = 0;
	while( word[i] !=0 )
		i++;
	len = i;
	word[i] = (-1) * word[Length1];
	for( i = len+1 , j = Length1 - 1; i <= j; i++, j--) {
		int c;
		c = word[i];
		word[i] = (-1) * word[j];
		word[j] = (-1) * c;
	}
	len = Length1 ;
  */

	fp2 = fopen( "wordout", "w" );

	if( Reduction( ) == 0 ) {
		fprintf( fp2, "The reduced word is empty\n" );
		printf( "The reduced word is empty\n" );
	} else {
		//fprintf( fp2, "The reduced Word is\n " );
		//printf( "The reduced Word is\n " );

    cout << "The reduced word is:\n";
		for( j = 0; j < len; j++) {
			fprintf( fp2, "%d ", word[j]);
			printf( "%d ", word[j]);
		}
    cout << "\n\n";

    int n = getStrands();
    cout << "strands is " << n << endl;
    int fullTwistLen = n * (n - 1);
    if (len * (fullTwistLen + 1) >= 10000) {
      cout << "Not enough memory\n";
      return 1;
    } else {
      // raise to (fullTwistLen + 1)th power
      for (int i = 1; i <= fullTwistLen; i++)
        for (int j = 0; j < len; j++)
          word[len * i + j] = word[j];
      len *= fullTwistLen + 1;
      word[len] = 0;
    }
    int floor = isSigmaPos() ? 0 : -1;
    while (floor >= 0) {
      if (len + fullTwistLen >= 1000) {
        cout << "Not enough memory\n";
        floor = -100;
      } else {
        // shift everything to the right by fullTwistLen
        for (int i = len; i >= 0; i--)
          word[i + fullTwistLen] = word[i];
        for (int i = 0; i < n; i++) {
          for (int j = 0; j < n - 1; j++)
            word[(n - 1) * i + j] = 1 - n + j;
        }
        //cout << "len is " << len << endl;
        len += fullTwistLen;
        //cout << "len is now " << len << endl;
        /*cout << "New word is: \n";
        for (int i = 0; i < len; i++)
          cout << word[i] << " ";
        cout << endl;
        */
        Reduction();
        /*
        cout << "Reduced new word is: \n";
        for (int i = 0; i < len; i++)
          cout << word[i] << " ";
        cout << endl;
        */
        if (isSigmaPos())
          floor++;
        else {
          cout << "Floor is " << floor << endl;
          break;
        }
      }
    }
	}


	fclose( fp1);
	fclose( fp2);
	return 0;
}
