USE [YAKES]
GO

/****** Object:  StoredProcedure [dbo].[yks_sp_GetSaldoDateCabang]    Script Date: 09/20/2016 16:19:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[yks_sp_GetSaldoDateCabang]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[yks_sp_GetSaldoDateCabang]
GO

USE [YAKES]
GO

/****** Object:  StoredProcedure [dbo].[yks_sp_GetSaldoDateCabang]    Script Date: 09/20/2016 16:19:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Enhancement yakes
-- Author		: Hamka Irama
-- Create date	: 21 September 2016
-- Description	: Get last saldo date, next saldo date and branch name
--                for report Perhitungan penarikan 100%
-- ERF          : 28-9-2016/460 
-- ============================================= 

CREATE PROCEDURE [dbo].[yks_sp_GetSaldoDateCabang]
@NIK varchar(10)
AS
BEGIN

declare 
@ClientID varchar(10) = (SELECT ClientID FROM YKS_MEMBER WHERE NIK = @NIK),
@Periode varchar(6)=NULL,
@Temp_Periode_Last integer=NULL,  
@Temp_Periode_Last_2 integer=NULL,  
@Periode_LAST varchar(30)=NULL,  
@Periode_LAST_2 varchar(30)=NULL,  
@Periode_NEXT varchar(30)=NULL,  
@Priod_MAX varchar(10)=NULL  
 
 
select @Periode = (SELECT MAX(PERIODE) FROM YKS_TRXN_MASTER WHERE CLIENTID=@ClientID)      
select @Periode = (select (CONVERT(INTEGER,@Periode)+1))  


if right(convert(varchar,@Periode,2),2) = '13'  
begin  
	select @Periode = (select convert(varchar,(convert(INTEGER,left(@Periode,4))+1))+'01')  
end 

select @Temp_Periode_Last = (select (CONVERT(INTEGER,RIGHT(MAX(Period),2))+1) from YKS_BILLING_HEADER)  
select @Temp_Periode_Last_2 = (select CONVERT(INTEGER,LEFT(MAX(Period),4)) from YKS_BILLING_HEADER)  
 
 
IF @Temp_Periode_Last=13  
begin  
	set @Temp_Periode_Last = 1  
	set @Temp_Periode_Last_2 = @Temp_Periode_Last_2+1  
end  
 
select @Periode_NEXT =(select datename(month,(Right(Replicate('0',2)+convert(varchar,@Temp_Periode_Last),2)+'-'+'01'+'-'+'2000'))+' '+RIGHT (REPLICATE('0',4)+CONVERT(VARCHAR,@Temp_Periode_Last_2),4))  
 
SELECT @Priod_MAX = (SELECT MAX(PERIODE) FROM YKS_TRXN_MASTER WHERE CLIENTID=@ClientID)  
 
select @Temp_Periode_Last = (select CONVERT(INTEGER,RIGHT(@Priod_MAX,2)))  
select @Temp_Periode_Last_2 = (select CONVERT(INTEGER,LEFT(@Priod_MAX,4)))  
 
IF @Temp_Periode_Last=0  
begin  
	set @Temp_Periode_Last = 12  
	set @Temp_Periode_Last_2 = @Temp_Periode_Last_2-1  
end  


select @Periode_LAST = (select Right(Replicate('0',2)+@Temp_Periode_Last,2)+'-'+'12'+'-'+RIGHT (REPLICATE('0',4)+CONVERT(VARCHAR,@Temp_Periode_Last_2),4))  
select @Periode_LAST_2=(select datediff(day, @Periode_LAST, dateadd(month, 1, @Periode_LAST)))  
set @Periode_LAST_2 = @Periode_LAST_2+' '+datename(month, @Periode_LAST)+' '+RIGHT (REPLICATE('0',4)+CONVERT(VARCHAR,@Temp_Periode_Last_2),4) 



SELECT @Periode_LAST_2 AS LastSaldoDate, @Periode_NEXT AS NextSaldoDate, B.Name AS BranchName
FROM YKS_MEMBER A
INNER JOIN YKS_COMPANY_UNIT B ON B.UnitID = A.UnitID
WHERE A.NIK = @NIK

END




GO


