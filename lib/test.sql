CREATE TABLE Tasks (
    Name TEXT, 
    DueDate DATETIME, 
    Description TEXT, 
    Priority NUMBER, 
    Difficulty NUMBER, 
    Location TEXT, 
    CompleteDate DATETIME, 
    SetDate DATETIME, 
    ID TEXT, 
    CONSTRAINT TASKS_PRIMARY_KEY PRIMARY KEY(ID)
    )