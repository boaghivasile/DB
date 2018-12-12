<p><b><h2> Task 1 </h2></b></p>
<p>Să se creeze un dosar Backup_labll. Să se execute un backup complet al bazei de date universitatea în acest dosar. Fișierul copiei de rezervă să se numească exercitiul1.bak. Să se scrie instrucțiunea SQL respectivă.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab11/Screens/Ex.1.PNG"  />

```sql

IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE NAME='device03')
EXEC sp_dropdevice 'device01' , 'delfile';
EXEC sp_addumpdevice 'DISK', 'device01',
			'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\device01_exercitiul11.bak'
GO 
BACKUP DATABASE universitatea
TO device03 WITH FORMAT,
NAME = N'universitatea-Full Database Backup'
GO
```

<p><b><h2> Task 2 </h2></b></p> 
<p>Să se scrie instrucțiunea unui backup diferențiat al bazei de date universitatea. Fișierul copiei de rezerva să se numească exercitiul2.bak.</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab11/Screens/Ex.2.PNG"  />

```sql

BACKUP DATABASE universitatea  
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul2.bak'  
WITH DIFFERENTIAL 
GO
BACKUP LOG universitatea TO DISK = 
		'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul2.bak'
```

<p><b><h2> Task 3 </h2></b></p> 
<p>Să se scrie instrucțiunea unui backup al jurnalului de tranzacții al bazei de date universitatea. Fișierul copiei de rezervă să se numească exercitiul3.bak .</p>

<img src="https://github.com/boaghivasile/DB/blob/master/Lab11/Screens/Ex.3.PNG"  />

```sql 
GO
EXEC sp_addumpdevice 'DISK', 'backup_Log', 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul3.bak'

GO
BACKUP LOG universitatea TO backup_Log
GO
```

<p><b><h2> Task 4 </h2></b></p> 
<p>Să se execute restaurarea consecutivă a tuturor copiilor de rezervă create. Recuperarea trebuie să fie realizată intr-o bază de date nouă universitatea_lab11. Fișierele bazei de date noi se află în dosarul BD_lab11. Să se scrie instrucțiunile SQL respective.</p> 

<img src="https://github.com/boaghivasile/DB/blob/master/Lab11/Screens/Ex4.PNG"  />

```sql
IF EXISTS (SELECT * FROM MASTER.sys.databases WHERE NAME='universitatea_lab11')
DROP DATABASE universitatea_lab11;
GO
RESTORE DATABASE universitatea_lab11
FROM DISK ='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul1.bak'
WITH MOVE 'universitatea' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\BD_lab11\data.mdf',
MOVE 'Indexes' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\BD_lab11\data1.ndf',
MOVE 'universitatea_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\BD_lab11\log.ldf',
NORECOVERY
GO
RESTORE LOG universitatea_lab11
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul3.bak'
WITH NORECOVERY
GO
RESTORE DATABASE universitatea_lab11
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul2.bak'
WITH NORECOVERY 
GO
```
