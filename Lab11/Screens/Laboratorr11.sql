/*Ex.1
Să se creeze un dosar Backup_labll. Să se execute un backup complet al bazei de date universitatea în acest dosar. 
Fișierul copiei de rezervă să se numească exercitiull.bak. Să se scrie instrucțiunea SQL respectivă.
*/

if exists (select * from master.dbo.sysdevices where name='device1')
exec sp_dropdevice 'device1' , 'delfile';
exec sp_addumpdevice 'DISK', 'device1',
			'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_Lab11\exercitiul1.bak'
go 
backup database universitatea
to device1 with format,
name = N'Full DATABASE BACKUP'
go

/*Ex.2
Să se scrie instrucțiunea unui backup diferențiat al bazei de date universitatea. 
Fișierul copiei de rezerva să se numească exercitiul2.bak .
*/

backup database universitatea  
to disk = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul2.bak'  
with differential 
go
backup log universitatea to disk = 
		'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul2.bak'

/*Ex.3
Să se scrie instrucțiunea unui backup al jurnalului de tranzacții al bazei de date universitatea.
Fișierul copiei de rezervă să se numească exercitiul3.bak .
*/

go
exec sp_addumpdevice 'DISK', 'backup_Log', 
			'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\EX3.bak'
go
backup LOG universitatea to backup_Log
go

/*Ex.4
Să se execute restaurarea consecutivă a tuturor copiilor de rezervă create. 
Recuperarea trebuie să fie realizată intr-o bază de date nouă universitatea_lab11. 
Fișierele bazei de date noi se află în dosarul BD_lab11. Să se scrie instrucțiunile SQL respective.
*/

if exists (select * from master.sys.databases where name='universitatea_new')
drop database universitatea_new;
go
restore database universitatea_new
with move 'universitatea' to 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DataBase_lab11\data.mdf',
move 'universitatea_File2' to 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DataBase_lab11\data1.ndf',
move 'universitatea_File3' to 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DataBase_lab11\data2.ndf',
move 'universitatea_log' to 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DataBase_lab11\log.ldf',
norecovery
go
restore log universitatea_new
from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\EX.bak'
with norecovery
go
restore database universitatea_new
from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup_lab11\exercitiul2.bak'
with norecovery 
go