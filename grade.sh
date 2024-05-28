#CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
CPATH='.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [[ -f student-submission/ListExamples.java ]]
then 
    echo "ListExamples.java found"
else
    echo "ListExamples.java file not found"
    echo "Grade: 0"
    exit
fi

#Step 3
cp TestListExamples.java student-submission/ListExamples.java grading-area
cp -r lib grading-area
#Step 4
cd grading-area
javac -cp $CPATH *.java 2>error.txt

if [[ $? -eq 0 ]]
then
    echo "Compiled successfully"
else
    echo "Failed to compile"
fi

java -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples > junit.txt
grep -i "failures" junit.txt > find.txt

pass=`grep "OK" junit.txt | cut -d "(" -f 1`
run=`cut -d "," -f 1 find.txt | cut -d ":" -f 2 | tail -1`
fail=`cut -d "," -f 2 find.txt | cut -d ":" -f 2 | tail -1`

if [[ "$pass" == "OK " ]]
then
  echo "Passed!"
  grade=100
else
    grade=$(( ((run - fail) * 100) / run))
fi
echo "Grade: $grade"
