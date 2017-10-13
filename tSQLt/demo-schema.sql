if not exits(select * from sys.databases where name = 'hr')
begin
	create database hr;
end
go
USE [hr]
GO
/****** Object:  Table [dbo].[users]    Script Date: 13/10/2017 22:17:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_name] [nvarchar](255) NOT NULL,
	[password] [nvarchar](255) NOT NULL,
	[company_id] [int] NOT NULL,
	[user_type_id] [int] NOT NULL,
	[pay_currency_id] [int] NOT NULL,
	[home_office_location_id] [int] NOT NULL,
	[contract_type_id] [int] NOT NULL,
	[parking_space_allocated] [int] NOT NULL,
	[holiday_schedule_id] [int] NOT NULL,
	[enabled] [int] NOT NULL,
	[department_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[annual_salary]    Script Date: 13/10/2017 22:17:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[annual_salary](
	[salary_id] [int] IDENTITY(1,1) NOT NULL,
	[valid_from] [datetime2](7) NOT NULL,
	[valid_to] [datetime2](7) NULL,
	[user_id] [int] NULL,
	[amount] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[salary_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[user_salaries]    Script Date: 13/10/2017 22:17:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[user_salaries](@date datetime2)
RETURNS TABLE 
AS
RETURN 
(	
	with user_salaries as (
    select s.user_id, s.amount, row_number() over(partition by s.user_id order by s.valid_from desc, s.valid_to) as row
        from dbo.annual_salary s 
            join dbo.users u on s.user_id = u.user_id 
        where 
            u.enabled = 1 and (s.valid_from < @date and (s.valid_to is null or s.valid_to > @date)))
        select user_id, amount from user_salaries where row = 1
)
GO
/****** Object:  Table [dbo].[companies]    Script Date: 13/10/2017 22:17:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[companies](
	[company_id] [int] IDENTITY(1,1) NOT NULL,
	[company_name] [nvarchar](255) NOT NULL,
	[primary_address_id] [int] NOT NULL,
 CONSTRAINT [PK_companies] PRIMARY KEY CLUSTERED 
(
	[company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[contacts]    Script Date: 13/10/2017 22:17:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contacts](
	[contact_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [nvarchar](50) NOT NULL,
	[last_name] [nvarchar](50) NOT NULL,
	[phone_number] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[contracts]    Script Date: 13/10/2017 22:17:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contracts](
	[contract_type_id] [int] IDENTITY(1,1) NOT NULL,
	[contract_description] [varchar](25) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[contract_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[currencies]    Script Date: 13/10/2017 22:17:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[currencies](
	[currency_id] [int] IDENTITY(1,1) NOT NULL,
	[currency_code] [varchar](3) NOT NULL,
 CONSTRAINT [PK_currencies] PRIMARY KEY CLUSTERED 
(
	[currency_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[department]    Script Date: 13/10/2017 22:17:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[department](
	[department_id] [int] IDENTITY(1,1) NOT NULL,
	[department_name] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[department_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[location]    Script Date: 13/10/2017 22:17:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[location](
	[location_id] [int] IDENTITY(1,1) NOT NULL,
	[address_line_1] [nvarchar](50) NOT NULL,
	[address_line_2] [nvarchar](50) NOT NULL,
	[address_line_3] [nvarchar](50) NOT NULL,
	[address_line_4] [nvarchar](50) NOT NULL,
	[address_line_5] [nvarchar](50) NOT NULL,
	[primary_contact_id] [int] NOT NULL,
 CONSTRAINT [PK_location] PRIMARY KEY CLUSTERED 
(
	[location_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[schedule]    Script Date: 13/10/2017 22:17:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[schedule](
	[schedule_id] [int] IDENTITY(1,1) NOT NULL,
	[date] [date] NOT NULL,
	[approved] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[schedule_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_types]    Script Date: 13/10/2017 22:17:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_types](
	[user_type_id] [int] NOT NULL,
	[user_type] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_user_types] PRIMARY KEY CLUSTERED 
(
	[user_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[schedule] ADD  DEFAULT ((0)) FOR [approved]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT ((0)) FOR [enabled]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT ((1)) FOR [department_id]
GO
ALTER TABLE [dbo].[annual_salary]  WITH CHECK ADD  CONSTRAINT [FK_annual_salary_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[annual_salary] CHECK CONSTRAINT [FK_annual_salary_users]
GO
ALTER TABLE [dbo].[companies]  WITH CHECK ADD  CONSTRAINT [FK_companies_location] FOREIGN KEY([primary_address_id])
REFERENCES [dbo].[location] ([location_id])
GO
ALTER TABLE [dbo].[companies] CHECK CONSTRAINT [FK_companies_location]
GO
ALTER TABLE [dbo].[location]  WITH CHECK ADD  CONSTRAINT [FK_location_contacts] FOREIGN KEY([primary_contact_id])
REFERENCES [dbo].[contacts] ([contact_id])
GO
ALTER TABLE [dbo].[location] CHECK CONSTRAINT [FK_location_contacts]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [FK_users_companies] FOREIGN KEY([company_id])
REFERENCES [dbo].[companies] ([company_id])
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [FK_users_companies]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [FK_users_contracts] FOREIGN KEY([contract_type_id])
REFERENCES [dbo].[contracts] ([contract_type_id])
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [FK_users_contracts]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [FK_users_currencies] FOREIGN KEY([pay_currency_id])
REFERENCES [dbo].[currencies] ([currency_id])
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [FK_users_currencies]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [FK_users_location] FOREIGN KEY([home_office_location_id])
REFERENCES [dbo].[location] ([location_id])
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [FK_users_location]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [FK_users_schedule] FOREIGN KEY([holiday_schedule_id])
REFERENCES [dbo].[schedule] ([schedule_id])
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [FK_users_schedule]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [FK_users_user_types] FOREIGN KEY([user_type_id])
REFERENCES [dbo].[user_types] ([user_type_id])
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [FK_users_user_types]
GO
/****** Object:  StoredProcedure [dbo].[AddAudit]    Script Date: 13/10/2017 22:17:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[AddAudit](@message varchar(max))
as

	
GO
