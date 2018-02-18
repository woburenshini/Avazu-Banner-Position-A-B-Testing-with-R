# Avazu Click-through rating A/B Testing with R

The **goal** of this A/B test is evaluate the click-through rate (CTR) as an important metric of online advertising. 

**Online advertising CTR = click through / Number of impressions**

The click-through rate of an advertisement is defined as the number of clicks on an ad divided by the number of times the ad is shown (impressions), expressed as a percentage.

We collect 10 days click-through data to discover if banner position is a factor of influent click-through rate. Top banner and side banner are represented as 0 and 1 in our dataset. 

Which position is a better batter: Side or Top banner?

Well, **Top banner** (position 1) has a slightly higher click-through rate (363 hits / 1941 click-through = **0.187**) than **Side banner** (position 0 )(1341 hits / 8054 click-through = **0.166**). But can we say with confidence that top banner is actually higher, or is it possible he just got lucky a bit more often?

In this series of posts about an empirical Bayesian approach to click-through rate statistics, we’ve been estimating click-through averages by modeling them as a binomial distribution with a beta prior. But we’ve been looking at a single position at a time. What if we want to compare two positions, give a probability that one is better than the other, and estimate by how much? 

Here, we’re going to look at an empirical Bayesian approach to comparing two positions. We’ll define the problem in terms of the difference between each batter’s posterior distribution, and look at four mathematical and computational strategies we can use to resolve this question. While we’re focusing on baseball here, remember that similar strategies apply to A/B testing, and indeed to many Bayesian models.

**Fist step Prepare Data**

The first step of our Avazu A/B test is load raw dataset and summarize feature of interest. We use R package dplyr for table manipulation.


![alt text](https://github.com/woburenshini/Avazu-Banner-Position-A-B-Testing-with-R/blob/master/Screen%20Shot%202018-02-18%20at%2011.20.33%20AM.png?raw=true)

Let's take a look at two positions in question

![alt text](https://github.com/woburenshini/Avazu-Banner-Position-A-B-Testing-with-R/blob/master/Screen%20Shot%202018-02-18%20at%2011.21.50%20AM.png?raw=true)


We see that Position 1 has a slightly higher average (click_no/count), and a higher shrunken empirical bayes estimate ((click_no+α0)/(count+α0+β0), where α0 and β0 are our priors).

But is Position true probability of getting a click-through rate higher? Or is the difference due to chance? To answer, let’s consider the actual posterior distributions- the range of plausible values for their “true” click-through averages after we’ve taken the evidence (their batting record) into account. Recall that these posterior distributions are modeled as beta distributions with the parameters Beta(α0+click_no,α0+β0+click_no+count).


![alt text](https://github.com/woburenshini/Avazu-Banner-Position-A-B-Testing-with-R/blob/master/Screen%20Shot%202018-02-18%20at%2011.20.49%20AM.png?raw=true)


![alt text](https://github.com/woburenshini/Avazu-Banner-Position-A-B-Testing-with-R/blob/master/Rplot01.png?raw=true)

**This posterior is a probabilistic representation of our uncertainty in each estimate. Thus, when asking the probability Top banner is better, we’re asking “if I drew a random draw from Top banner and a random draw from Side banner, what’s the probability Top banner is higher”? Well, notice that those two distributions does not overlap a lot. There’s enough certainty in each of those estimates that Side banner could not easily be better than Top banner.**
