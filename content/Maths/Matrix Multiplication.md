---
tags:
  - maths
  - matrices
---
>[!error]This article is a work in progress.

Matrix multiplication is.. a bit confusing. But only at first!

Let's start off the same way I was originally taught by maths tutor - with this exact example.

A salesperson sells items of three types I, II, and III, costing €10, €20, and €30.
The table will show how many items of each type are sold on Monday morning and afternoon.

|           | Type I | Type II | Type III |
| --------- | ------ | ------- | -------- |
| Morning   | 3      | 4       | 1        |
| Afternoon | 5      | 2       | 2        |

Let's convert this table into the matrix $A$:

$
\begin{pmatrix}
3 & 4 & 1 \\
5 & 2 & 2 \
\end{pmatrix}
$

We will take $B$ to be a 3x1 matrix containing the price of the items, like so:

$B =
\begin{pmatrix}
10 \\
20 \\
30 \\
\end{pmatrix} 
$

*Remember: $B$ is a column vector - Please see [[Introduction to Matrices]].*

Now, $C$ is a 2x1 matrix (another column vector) whose entries are the total income from the morning and afternoon sales.


$C=
\begin{pmatrix}
140 \\
150 \\
\end{pmatrix}
$

> [!question]- Lost?
> The values are from the total incomes, so the 140 comes from $(3*10) + (4*20) + (1*30)$
> 

