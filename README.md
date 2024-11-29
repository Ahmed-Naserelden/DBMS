# Bash Shell Script Database Management System (DBMS)  

## **Project Description**  
This project is a **Database Management System (DBMS)** implemented in Bash shell scripting. It allows users to create and manipulate databases directly on the file system. The system supports two versions:  

1. **Menu-Based Version:**  
   A command-line interface (CLI) that provides menu-based navigation for database operations.
   
2. **SQL-Based Version:**  
    A command-line interface (CLI) that allows users to execute SQL-like queries for database management.
---

## **Features**  

### **1. Menu-Based Version**  

#### **Main Menu:**  
When the user runs the script, the following options are presented:  
1. **Create Database:**  
   Create a new database (stored as a directory).  
2. **List Databases:**  
   Display all existing databases.  
3. **Connect to Database:**  
   Connect to a specific database to manage tables and data.  
4. **Drop Database:**  
   Delete an existing database and all its contents.  
5. **SQL Mode**
    write sql queries alternative menue

#### **Database Management Menu:**  
Once connected to a database, the user can perform the following operations:  
1. **Create Table:**  
   - Specify table name, columns, and their data types.  
   - Define a **primary key** to enforce uniqueness.  
2. **List Tables:**  
   Display all tables within the connected database.  
3. **Drop Table:**  
   Delete a table and its contents.  
4. **Insert into Table:**  
   - Add new rows to a table.  
   - Validate data types and ensure the uniqueness of primary keys.  
5. **Select From Table:**  
   - Retrieve and display data from a table.  
   - Support for selecting all columns or specific columns.  
   - Filter data using conditions (`=`, `!=`, `<`, `>`, `<=`, `>=`).  
   - Apply filtering with one condition only (e.g., WHERE column = value).
6. **Delete From Table:**  
   - Remove rows based on a single condition (e.g., WHERE column = value).
7. **Update Table:**  
   - Modify existing records by updating column values.  
   - Support updates based on a single condition (e.g., WHERE column = value) while ensuring primary key integrity and data type validation.

### **2. SQL-Based Version**

- Supports SQL-like commands for database operations. Examples include:
    ``` bash
        isql> use hr;
        isql> SELECT employee_id, first_name
              FROM employees
              WHERE salary >= 5000;

    ```

## **Technical Details**  

- **Database Storage:**  

    - Databases are implemented as directories.
    - Tables are represented as files, with each file storing table rows.
    - Metadata files store information about table structure and primary keys.

The system organizes files and directories as follows:

- **File Structure:**  
  ```
    ├── B2RADB_HOME
    │   ├── database1
    │   │   ├── table1
    |   |   ├── table2
    │   │   └── .metadata
    |   |       ├── table1
    │   │       └── table2
    │   └── database2
    │       ├── .metadata
    │       │   └── table1
    │       └── table1
    ├── setup (setup script)
    ├── run-isql.sh (SQL mode)
    └── run.sh (Menu mode)
---


## Installation

Provide step-by-step instructions to set up the project locally.

1. **Clone the Repository**: Begin by cloning the repository to your local machine:
   ```bash
   git clone https://github.com/Ahmed-Naserelden/DBMS.git
    ```

2. **Navigate to the Project Directory**: Move into the project directory:
    ```bash
    cd DBMS
    ```

3. **Setup** run `setup` script
    ```bash
    ./setup
    ```
## **How to Run** 

### **CLI-Menue-Based Version**  
1. Open a terminal.  
2. Navigate to the directory containing the `run.sh` script.  
3. Run the script using:  
   ```bash  
   ./run.sh  
   ```  

---

### **CLI-SQL-Based Version**  
1. Open a terminal.  
2. Navigate to the directory containing the `run-isql.sh` script.  
3. Run the script using:  
   ```bash  
   ./run-isql.sh
   ```  


---
### Future Enhancements

- SQL Features:
Expand support for complex SQL queries, including joins, nested queries, and aggregations.

- Performance Optimization:
Introduce indexing to improve data retrieval speeds.

- Concurrency Control:
Add support for multi-user access with file locking or transactional mechanisms.

-   Graphical Interface:
Implement a GUI for users who prefer visual interaction over the command line.


## Contributing

Contributions are welcome! Please fork the repository, make your changes, and submit a pull request.
