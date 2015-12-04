## Netflix Movie Recommendation System (Netflix Prize)

This is a movie recommendation system based on **Netflix Prize** contest and the dataset published by Netflix about how users rated different movies in a certain period of time. You can read more about the contest at [this Wikipedia Entry](http://en.wikipedia.org/wiki/Netflix_Prize). Some information about the data:

```
- Number of users:   480,189
- Number of movies:  17,770
- Number of ratings: 100,480,507
```

Training Data Set is distributed over **17,770** files, *one* for each *movie* and in each file the information about how different users rated that movie can be found in the followin format

```


			   user-id 	|   movie-rating	|	date
			--------------------------------------------
			   1488844			 3			  2005-09-06
			   372233			 5			  2005-11-23
			   427928			 4			  2004-02-26
			
```

In this implementation the date of the rating was **not** considered. That of course is a valuable piece of information but for simplicity purposes, we used a ``dimensionality reduciton`` on this and did not consider that dimension of the dataset. Note that at the time of the Netflix Prize Contest, **Cinematch** -Netflix' recommendation engine- did **NOT** use date of rating either, we don't know whehter they use that information now or not! 

**Three** different approaches used for predicting a movie rating by a given user. We will discuss these different approaches and compare them to each other in the following sections. But before that, a little on the data preprocessing phase and what kinds of information has been extracted out of the original data set.

### Data Preprocessing

As you know in data mining tasks, usually a big part of the process is doing some preprocessing on the dataset and create dataset(s) out of it in a way which will make the *further processes*, *algorithms* and *analysis* ``easier and simpler``. And they only contain relevant data based on the kind of analysis we want to do on the data.

In order to do the Clustering and Pearson Correlation Coefficient algorithms in a more efficient way and a bit simpler, some preprocessing on the original files and data was done. Also these two algorithms were the "more" complicated algorithms out of the three approaches we tried and operated on a small subset of the original data using **Random Sampling Without Replacement**

We grabbed a random sample of users with the size of **2000** and also a random sample of movies by the same size as well. Then we found all the movies (out of those 2000 random samples) rated by each of those users and created a file for each user in the following format:

```
1488844
0000001:4
0000052:2
0003435:3
0001530:5
...
```

All these data preprocessing tasks were done by **UNIX Bash Scirpts** which can be found in the code.

### Clustering

The first approach used in order to predict a movie rating by a user was **Clustering**. In this appraoch in order to predict the rating of the movie ``M1`` by user ``U1``, the following steps are being executed.

- Find all the users who rated the movie ``M1`` (These are candidate users for further processing)
- For each of those users find out how they rated movies which are rated by user ``U1``
- If a user did not for any of those movies, consider the rating value **ZERO** which will be filtered in the following steps
- At this point we created a semi-similarity matrix between the user under prediction and other candidate users which looks like the following:

```
       movie2 movie3 movie4 movie5
       ____________________________
user1 |	  1	  |	 3	 |	2	|	2  |
user2 |	  3	  |	 3	 |	0	|	1  |
user3 |	  0	  |	 1	 |	4	|	5  |
user4 |	  2	  |	 0	 |	4	|	3  |
	   ----------------------------

```

After having this similarity matrix, we calculated the distance between user ``U1`` and each of the candidate users using the **euclidean distance**! Note that in order to calculate the distance between ``U1`` and each candidate user, *ONLY* the movies rated by *BOTH* of them were considered in the calculation for more accuracy.

Then the closer half is labeled as the **Similar-Users** and the further half as **Non-Similar-Users**! Now in order to predict the rating of the movie ``M1`` by user ``U1``, we calculated the **average** rating of the Similar-Users for movie ``M1`` and that is the **predicted rating** of that movie for user ``U1``.

### Pearson Correlation Coefficient

On of the main issues with the Clustering approach we just discussed, is that it ignores some useful information which is actually quite meaningful in this context. We completely ignore the further half or the Non-Similar-Users. But if someone rated a movie ``1`` in the Non-Similar-Users cluster, that can mean the user under prediction which is ``U1`` might rate that movie ``4`` or ``5`` since they have different tastes. In order to consider all the information from the candidate users, we use the second approach which is using **Pearson Correlation Coefficient**.

The second approach was using the **Pearson Correlation Coefficient** whicn you can read about it in more details [here](http://en.wikipedia.org/wiki/Pearson_product-moment_correlation_coefficient).

Again we shape the similarity matrix between the user ``U1`` and the candidate users the same way we discussed in Clustering section. In this appraoch we also need the average of movie rating by user ``U1`` and each of the candidate users. Then by using the Pearson Correlation we calcualte the weight between user ``U1`` and each of the candidate users. Then we use the value of the calculated weights in the following formula in order to predict the movie rating by user ``U1``:

```
avg_U1 = averge-of-rating-by-U1
avg_Ui = avarge-of-rating-by-candiate-user-Ui
avg_weights = average-of-calculated-weights ==> This is a normalizer factor
Ri = rate-of-M1-by-candidate-user-Ui
predicted-rate-for-M1 = avg_U1 + [Summation(Ri - avg_Ui) for each Ui] / avg_weights
```

And that gives us the predicted rate of movie ``M1`` by user ``U1`` by using the information extracted out of **all** the candidate users *not just the similar ones*.

### Averaging Other Ratings of User / Averaging Other Users Rating

This is the simplest approach of all and it uses **WAY** bigger amount of data. It actually uses **ALL** the data available from Netflix which we talked about at the beginning.

In this approach the steps pretty straightforward. The first one is *Averating Other Ratings by User*:

- Get all the other movie ratings by user ``U1``
- Calculate the average of those ratings and that is the *predicted rate*

The other one is *Averaging what other users rated for movie ``M1``*:

- Get all the other users ratings for movie ``M1``
- Calculate the average of those ratings and that is the *predictted rate*

### More Data with Simple Algorithms VS Less Data with Complicated Algorithms

One of the school of thoughts in the field of Data Mining and Machine Learning is that if you have *more data available with a simple algorithm*, that can give you a better result than *using a complicated algorithm with less amount of data*. This is basically emphasizing the **important role of data** itself and how it can impact the result of your analysis and process.

The following table shows the rating prediction result of these three approaches for user id **1003353** and six different movies:

```

		     0008387  |  0009049  |  0010042  |  0011283  |  0012084  |  0016139  
---------------------------------------------------------------------------------
Clustering		3.64  |    3.64   |    4.52   |    4.27   |    3.33   |    3.67
---------------------------------------------------------------------------------
Pearson CC      4.17  |    4.06   |    4.57   |   4.32    |    3.64   |    4.19
---------------------------------------------------------------------------------
Avg of Other    3.52  |    3.5    |    3.47   |   3.47    |    3.5    |    3.52
movie Ratings	    
---------------------------------------------------------------------------------
Actual Ratign     3   |     4     |      5    |     5     |     4     |     3

```

### Some thoughts on the Test Results

- According to several tests on different users and movies, it looks like in different scenarios (user, movies, other candidate users in each situation, etc.) different approaches acted differently. In some cases *Clustering* did better and in some other cases *Pearson Correlation Coefficient* and so on. In the test cases we ran, **Clustering** mostly did a decent job.

- The average in this context is not acting very good since majority of the ratings by this approach is predicted around 3.5 or something close to that value which is either *average of ratings by the user under prediction for other movies* or *average of other user's ratings for the movie under prediction*!

- One other important thing to consider is that, we did a random sampling in clustering and pearson correlation coefficient appraoches! The data we're dealing with have the potential of not being a very good set for our approaches specially in some cases when a particular user did not rate many movies or other users did not rate a movie the user under prediction rated or the like sitations. For instance in case of one user PCC acted very poorly and further investigation showed that a lot of the candidate users have a very small subset in common with the user under prediction and that can highly affect the calculation of weights between users which will of course affect the result of movie rating prediction in this algorithm.
- The evaluation was done by calculating *RMSE (Root Mean Squared Error)* for each approach based on its predictions and actual ratings of the user and you can see some of those RMSEs in the following table:

```
User: 725544 
Movies: 
	'Miss Congeniality', 'Agent Cody Banks 2', 
	'Maid in Manhattan', 'Double Jeoparday', 
	'Legally Blonde'

RMSE Values
Clustering									  |  0.642455650814589
Pearson Correlation Coefficient	    		  |  1.7610623698519767
Averaging Other User's Ratings For the Movie  |  * 0.6200467226186842 *
============================================================================
User: 1003353
Movies: 
	'Minority Report', 'Boogie Nights', 
	'Raiders of the Lost Ark', 'Forrest Gump', 
	'Adaptation', 'Father of the Bride'

RMSE Values
Clustering							   | * 0.6026199215968864 *
Pearson Correlation Coefficient		   | 0.7738239443797152
Averaging Other Movie Raitngs By User  | 0.9740588418376253
============================================================================
User 2577095
Movies:
	'About a Boy', 'Black Hawk Down', 
	'Groundhog Day', 'Forrest Gump'
RMSE Values
Clustering						  | 0.6936692090808817
Pearson Correlation Coefficient	  | * 0.6767672220290791 *
```



### Working with HUGE Data

- Working with this kind of data on a single machien is **IMPOSSIBLE** (in practical terms)
- You need to parallelize the process for the data preprocessing and also algorithms execution.
- Hadoop to the rescue (You don't have to be worried about Network, File Permission, File System Related Details and Operations, etc. Focus on the main problem at hand and run your tasks in parallel on different nodes of multiple clusters with linear scalability)