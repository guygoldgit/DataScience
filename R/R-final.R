
#### On Linux server:
library(DBI)
con <- dbConnect(odbc::odbc(), .connection_string = "Driver={ODBC Driver 17 for SQL Server};server=192.168.1.1;
database=COLLEGE;uid=dsuser04;
pwd=DSuser04!", timeout = 10)

#### On Windows:
library(DBI)
con <- dbConnect(odbc::odbc(), .connection_string = "DSN=COLLEGE;Trusted_Connection=yes;", timeout = 10)

## Get the whole table:
df <- dbReadTable(con, "Classrooms")
inner_


library(dplyr)


library(dplyr)
library(DBI)
con <- dbConnect(odbc::odbc(), .connection_string = "DSN=COLLEGE;Trusted_////connection=yes;", timeout=10)


Students <- dbReadTable(con,"Students$")

View(Students)
Students <- Students[1:280,]
View(Students)

Classrooms <- dbReadTable(con,"Classrooms$")

View(Classrooms)
Classrooms <- Classrooms[1:754,]
View(Classrooms)

Courses <- dbReadTable(con,"Courses$")

View(Courses)
Courses <- Courses[1:31,]
View(Courses)

Teachers <- dbReadTable(con,"Teachers$")
View(Teachers)
Teachers <- Teachers[1:24,]

df1 <- inner_join(Students,Classrooms,by="StudentId")
df1 <- inner_join(df1,Courses,by="CourseId")
View(df1)


df1$DepartmentName[df1$DepartmentID == 1] <- " English"
df1$DepartmentName[df1$DepartmentID == 2] <- " Science"
df1$DepartmentName[df1$DepartmentID == 3] <- "Arts"
df1$DepartmentName[df1$DepartmentID == 4] <- "Sport"
View(df1)

## Questions

##############
## Q1. Count the number of students on each department¶
##############
deptbystud <- df1 %>% group_by(DepartmentName,StudentId) %>% summarise(mean(degree))
View(deptbystud  %>% group_by(DepartmentName) %>% summarise(count=n()))

##############
## Q2. How many students have each course of the English department and the 
##     total number of students in the department?
##############
English <- df1 %>% filter(DepartmentID==1)
View(English)


English %>% group_by(CourseName) %>% summarise(count=n())
English1 <- English %>% unique()%>% group_by(StudentId) %>% summarise(count=n())
nrow(English1)



##############
## Q3. How many small (<22 students) and large (22+ students) classrooms are 
##     needed for the Science department?
##############
Science <- df1 %>% filter(DepartmentID==2)
View(Science)
Science1 <- Science %>% group_by(CourseName) %>% summarize(count=n())
View(Science1)


Science1$size[Science1$count < 22] <- " small"
Science1$size[Science1$count >= 22] <- " large"

View(Science1)
Science1 %>% group_by(size) %>% summarise(count=n())

##############
## Q4. A feminist student claims that there are more male than female in the 
##     College. Justify if the argument is correct
##############
Students %>% group_by(Gender) %>% summarise(count=n()) 

##############
## Q5. For which courses the percentage of male/female students is over 70%?
##############
df1$IsMale[df1$Gender == "M"] <- 1
df1$IsMale[df1$Gender == "F"] <- 0

df1$IsFemale[df1$Gender == "M"] <- 0
df1$IsFemale[df1$Gender == "F"] <- 1

Coursesgender <- df1 %>% group_by(CourseName) %>% 
  summarise(Males=sum(IsMale,na.rm = TRUE),Females=sum(IsFemale,na.rm = TRUE))
Coursesgender <- Coursesgender %>% mutate(MalePercent=Males*100/(Males+Females),FeMalePercent=Females*100/(Males+Females))
View(Coursesgender)
Coursesgender %>% filter(FeMalePercent>70)


##############
## Q6. For each department, how many students passed with a grades over 80?
##############
DptGrade <- df1 %>% group_by(DepartmentName,StudentId) %>% summarise(mean(degree))
View(DptGrade)
DptGrade$High[DptGrade$`mean(degree)` > 80] <- 1
DptGrade$High[DptGrade$`mean(degree)` <= 80] <- 0
DptGrade$Med[DptGrade$`mean(degree)` > 80] <- 0
DptGrade$Med[DptGrade$`mean(degree)` <= 80] <- 1
View(DptGrade)

dptmeananalysis <- DptGrade %>% group_by(DepartmentName) %>% summarise(TotalHigh=sum(High),TotalMed=sum(Med))
View(dptmeananalysis)
dptmeananalysis %>% mutate(Highavgper=TotalHigh*100/(TotalHigh+TotalMed),Medavgper=TotalMed*100/(TotalHigh+TotalMed))


##############
## Q7. For each department, how many students passed with a grades under 60?
##############


DptGrade$Pass[DptGrade$`mean(degree)` >= 60] <- 1
DptGrade$Pass[DptGrade$`mean(degree)` <= 60] <- 0
DptGrade$Fail[DptGrade$`mean(degree)` >= 60] <- 0
DptGrade$Fail[DptGrade$`mean(degree)` <= 60] <- 1
View(DptGrade)

dptmeananalysis1 <- DptGrade %>% group_by(DepartmentName) %>% summarise(TotalPass=sum(Pass),TotalFail=sum(Fail))
View(dptmeananalysis1)
dptmeananalysis1 %>% mutate(Passper=TotalPass*100/(TotalPass+TotalFail),Failper=TotalFail*100/(TotalPass+TotalFail))

##############
## Q8. Rate the teachers by their average student's grades (in descending order).
##############
df2=inner_join(Classrooms,Courses, by="CourseId")
df2=inner_join(df2,Teachers,by="TeacherId")
TeachersRank <- df2 %>% group_by(FirstName,LastName) %>% summarise(avg=mean(degree))
TeachersRank %>% arrange(desc(avg))


##############
## Q9. Create a dataframe showing the courses, departments they are associated with, 
##     the teacher in each course, and the number of students enrolled in the course 
##     (for each course, department and teacher show the names).
##############
df2$DepartmentName[df2$DepartmentID == 1] <- " English"
df2$DepartmentName[df2$DepartmentID == 2] <- " Science"
df2$DepartmentName[df2$DepartmentID == 3] <- "Arts"
df2$DepartmentName[df2$DepartmentID == 4] <- "Sport"

df2 %>% group_by(CourseName,DepartmentName,FirstName,LastName) %>% summarise(count=n())


##############
## Q10. Create a dataframe showing the students, the number of courses they take, 
##      the average of the grades per class, and their overall average (for each student 
##      show the student name).
##############
df1$EnglishDegree[df1$DepartmentID == 1] <- df1$degree
df1$ScienceDegree[df1$DepartmentID == 2] <- df1$degree
df1$ArtsDegree[df1$DepartmentID == 3] <- df1$degree
df1$SportDegree[df1$DepartmentID == 4] <- df1$degree
studentsview <- df1 %>% group_by(StudentId,FirstName,LastName) %>% summarise(count=n(),
                                                                             mean(EnglishDegree,na.rm = T)
                                                                             ,mean(ScienceDegree,na.rm = T)
                                                                             ,mean(ArtsDegree,na.rm = T)
                                                                             ,mean(SportDegree,na.rm = T)
                                                                             ,mean(degree,na.rm = T))
View(studentsview)


