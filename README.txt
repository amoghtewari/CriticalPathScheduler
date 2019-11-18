TO TEST predicates, load both sampleX.pl and q3.pl

Implemented predicates include:
1. earlyStart(Task, Time) 
	binds earliest starting time of Task to Time.
	example: earlyStart(a,X). evaluates true and binds X to early Start of X.
2. earlyFinish(Task, Time) 
	binds earliest finishing time of Task to Time.
	example: earlyFinish(a,X). evaluates true and binds X to early Finish of X.
3. lateStart(Task, Time) 
	binds latest starting time of Task to Time.
	example: lateStart(a,X). evaluates true and binds X to late Start of X.
4. lateFinish(Task, Time) 
	binds latest finishing time of Task to Time.
	example: lateFinish(a,X). evaluates true and binds X to late Finish of X.

5. slack(Task, Time)
	binds the slack of Task to Time.
	example: slack(a,X). evaluates true and binds X to slack of a.

6. maxSlack(Task, Time)
	evaluates to true if and only if Time is the maximum slack of any all tasks in DB 	and Task's slack is equal to Time.
	example(for file sampleB): maxSlack(f, 30) evaluates true.

7. criticalPath(Task, Path)
	evaluates to true if and only if path is an ordered list of critical path to Task.
	example(for file sampleB): criticalPath(g, [a,l,m,n,j,k,g]) evaluates true.
	example(for file sampleB): criticalPath(j, [a,l,m,n,j]) evaluates true.