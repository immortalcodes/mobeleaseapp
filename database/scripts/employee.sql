PGDMP     0    6                {         	   mobelease    15.4 (Debian 15.4-1.pgdg120+1)     15.4 (Ubuntu 15.4-1.pgdg22.04+1) 	               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16384 	   mobelease    DATABASE     t   CREATE DATABASE mobelease WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';
    DROP DATABASE mobelease;
                admin    false            �            1259    32776    Employee    TABLE       CREATE TABLE public."Employee" (
    "EmployeeID" integer NOT NULL,
    "EmployeePhoto" bytea,
    "FirstName" character varying(50),
    "LastName" character varying(50),
    "PhoneNo" character varying(15),
    "Password" character varying(300),
    "Email" character varying(100)
);
    DROP TABLE public."Employee";
       public         heap    admin    false            �            1259    32775    Employee_EmployeeID_seq    SEQUENCE     �   CREATE SEQUENCE public."Employee_EmployeeID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public."Employee_EmployeeID_seq";
       public          admin    false    215                       0    0    Employee_EmployeeID_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public."Employee_EmployeeID_seq" OWNED BY public."Employee"."EmployeeID";
          public          admin    false    214            ~           2604    32779    Employee EmployeeID    DEFAULT     �   ALTER TABLE ONLY public."Employee" ALTER COLUMN "EmployeeID" SET DEFAULT nextval('public."Employee_EmployeeID_seq"'::regclass);
 F   ALTER TABLE public."Employee" ALTER COLUMN "EmployeeID" DROP DEFAULT;
       public          admin    false    214    215    215            �           2606    32783    Employee Employee_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public."Employee"
    ADD CONSTRAINT "Employee_pkey" PRIMARY KEY ("EmployeeID");
 D   ALTER TABLE ONLY public."Employee" DROP CONSTRAINT "Employee_pkey";
       public            admin    false    215           