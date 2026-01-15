/*Write a PL/SQL block that allows inserting or updating an employee’s first name in the EMPLOYEES table.
  1.If the employee ID already exists, update the first name.
  2.If it does not exist, insert a new record.
  3.Ensure that employee IDs below 100 are not allowed, and handle errors gracefully.*/
  
SET SERVEROUTPUT ON
DECLARE
    V_EMP_ID   EMPLOYEES.EMPLOYEE_ID%TYPE := &EMP_ID;
    V_EMP_NAME EMPLOYEES.FIRST_NAME%TYPE  := '&EMP_NAME';
BEGIN  
    
    IF V_EMP_ID < 100
    THEN 
        DBMS_OUTPUT.PUT_LINE('PLEASE PUT EMP ID VALUE AS ABOVE 100');
    END IF;
    
    MERGE INTO EMPLOYEES E
    USING (SELECT V_EMP_ID EMP_ID, V_EMP_NAME EMP_NAME FROM DUAL) USER_SRC
    ON (E.EMPLOYEE_ID = USER_SRC.EMP_ID)
    WHEN MATCHED THEN
        UPDATE SET E.FIRST_NAME = USER_SRC.EMP_NAME
    WHEN NOT MATCHED THEN
        INSERT (EMPLOYEE_ID, FIRST_NAME) 
        VALUES (USER_SRC.EMP_ID, USER_SRC.EMP_NAME);
        
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('MERGE SUCCESSFUL');

EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR : ' || SQLERRM);
END;
/