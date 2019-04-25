USE [YAKES]
GO

/****** Object:  StoredProcedure [dbo].[yks_sp_GetDataPWDByNik]    Script Date: 09/09/2016 17:29:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[yks_sp_GetDataPWDByNik]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[yks_sp_GetDataPWDByNik]
GO

USE [YAKES]
GO

/****** Object:  StoredProcedure [dbo].[yks_sp_GetDataPWDByNik]    Script Date: 09/09/2016 17:29:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
-- =============================================
-- Enhancement yakes
-- Author		: Hamka Irama
-- Create date	: 21 September 2016
-- Description	: Get data Partial Withdrawal base on NIK
-- ERF          : 28-9-2016/460 
-- ============================================= 
CREATE PROCEDURE [dbo].[yks_sp_GetDataPWDByNik]  
 (  
 @NIK varchar(30) 
 )  
AS  
BEGIN 
	SELECT * 
	FROM YKS_TRXN_WITHDRAWAL A
	INNER JOIN YKS_MEMBER B ON (B.ClientID = A.ClientID)
	WHERE 
	B.NIK = @NIK
END  
  
GO


