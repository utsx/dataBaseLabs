CREATE TYPE УРОВЕНЬ_ТУРНИРА AS ENUM (
    'МЕЖДУНАРОДНЫЙ',
    'ВСЕРОССИЙСКИЙ',
    'РЕГИОНАЛЬНЫЙ',
    'РЕСПУБЛИКАНСКИЙ/ОБЛАСТНОЙ',
    'МУНИЦИПАЛЬНЫЙ'
    );

CREATE TYPE РОЛЬ AS ENUM (
    'СПОРТСМЕН',
    'ТРЕНЕР'
    );

CREATE TYPE УРОВЕНЬ AS ENUM (
    'ОТБОРОЧНЫЙ',
    'ПЛЕЙ-ОФФ'
);

CREATE TYPE ДОЛЖНОСТЬ AS ENUM (
    'ГЛАВНЫЙ СУДЬЯ СОРЕВНОВАНИЙ',
    'СТАРШИЙ СУДЬЯ ТУРА',
    'СУДЬЯ МАТЧА',
    'СУДЬЯ-ХРОНОМЕТРИСТ',
    'СУДЬЯ-СТАТИСТИК'
    );

CREATE TYPE ПРИВИЛЕГИЯ AS ENUM (
    'ЭКОНОМ',
    'КОМФОРТ',
    'БИЗНЕС',
    'ПРЕМИУМ',
    'VIP'
    );

CREATE TYPE ТИП_СОБЫТИЯ AS ENUM (
    'ЗАМЕНА',
    'ШТРАФ',
    'ЛОУ КИК'
    );

CREATE TABLE ОРГАНИЗАЦИЯ
(
    ОГРН                     varchar(50) PRIMARY KEY,
    НАИМЕНОВАНИЕ_ОРГАНИЗАЦИИ VARCHAR(512) NOT NULL,
    ИНН                      varchar(50)  NOT NULL,
    КПП                      varchar(50)  NOT NULL,
    МЕСТО_НАХОЖДЕНИЯ         VARCHAR(512) NOT NULL,
    ПОЧТОВЫЙ_АДРЕС           varchar(512) NOT NULL
);

CREATE TABLE СТАДИОН
(
    ID                    INTEGER PRIMARY KEY,
    НАИМЕНОВАНИЕ_СТАДИОНА VARCHAR(256),
    КОЛИЧЕСТВО_ПОЛЕЙ      INTEGER      NOT NULL CHECK ( КОЛИЧЕСТВО_ПОЛЕЙ > 0 ),
    КОЛИЧЕСТВО_МЕСТ       INTEGER      NOT NULL,
    АДРЕС                 VARCHAR(256) NOT NULL,
    ID_ОРГАНИЗАЦИИ        varchar(50) NOT NULL,
    FOREIGN KEY (ID_ОРГАНИЗАЦИИ) REFERENCES ОРГАНИЗАЦИЯ (ОГРН)
);

CREATE TABLE ТУРНИР
(
    ID              INTEGER PRIMARY KEY,
    НАЗВАНИЕ        VARCHAR(256)    NOT NULL,
    ДАТА_НАЧАЛА     DATE            NOT NULL,
    ДАТА_КОНЦА      DATE            NOT NULL,
    ПРИЗОВОЙ_ФОНД   INTEGER         NOT NULL,
    УРОВЕНЬ_ТУРНИРА УРОВЕНЬ_ТУРНИРА NOT NULL,
    ID_СТАДИОНА     INTEGER         NOT NULL,
    FOREIGN KEY (ID_СТАДИОНА) REFERENCES СТАДИОН (ID)
);


CREATE TABLE РЕГЛАМЕНТ
(
    ID              integer PRIMARY KEY,
    ДЕЙСТВУЮЩИЙ     BOOLEAN,
    ID_ТУРНИРА      INTEGER         NOT NULL,
    ДАТА_УТВЕРЖДЕНИЯ DATE NOT NULL,
    FOREIGN KEY (ID_ТУРНИРА) REFERENCES ТУРНИР (ID)
);

CREATE TABLE ПРАВИЛО
(
    ID    INTEGER PRIMARY KEY,
    ТЕКСТ TEXT NOT NULL
);

CREATE TABLE ПРАВИЛО_В_РЕГЛАМЕНТЕ
(
    ID_РЕГЛАМЕНТА INTEGER NOT NULL,
    ID_ПРАВИЛА    INTEGER NOT NULL,
    FOREIGN KEY (ID_РЕГЛАМЕНТА) REFERENCES РЕГЛАМЕНТ (ID),
    FOREIGN KEY (ID_ПРАВИЛА) REFERENCES ПРАВИЛО (ID)
);


CREATE TABLE ГРУППА
(
    ID    INTEGER PRIMARY KEY,
    НОМЕР         INTEGER NOT NULL,
    ID_ТУРНИРА    INTEGER NOT NULL,
    УРОВЕНЬ      УРОВЕНЬ NOT NULL,
    FOREIGN KEY (ID_ТУРНИРА) REFERENCES ТУРНИР (ID)
);

CREATE TABLE МАТЧ
(
    ID                INTEGER PRIMARY KEY,
    ДАТА_ПРОВЕДЕНИЯ   DATE      NOT NULL,
    ID_ГРУППЫ        INTEGER   NOT NULL,
    FOREIGN KEY (ID_ГРУППЫ) REFERENCES ГРУППА (ID)
);

CREATE TABLE ПРОТОКОЛ_МАТЧА
(
    ID INTEGER PRIMARY KEY,
    ID_МАТЧА INTEGER NOT NULL UNIQUE,
    НАЧАЛО_МАТЧА DATE NOT NULL,
    КОНЕЦ_МАТЧА DATE NOT NULL,
    ID_ПОБЕДИТЕЛЯ INTEGER,
    FOREIGN KEY (ID_МАТЧА) REFERENCES МАТЧ (ID)
);


CREATE TABLE КОМАНДА
(
    ID           INTEGER PRIMARY KEY,
    НАЗВАНИЕ     VARCHAR(256) NOT NULL,
    ГОРОД        VARCHAR(256) NOT NULL,
    ПОДТВЕРЖДЕНА BOOLEAN      NOT NULL
);


CREATE TABLE КОМАНДА_В_МАТЧЕ
(
    ID_КОМАНДА INTEGER NOT NULL,
    ID_МАТЧ    INTEGER NOT NULL,
    FOREIGN KEY (ID_КОМАНДА) REFERENCES КОМАНДА (ID),
    FOREIGN KEY (ID_МАТЧ) REFERENCES МАТЧ (ID)
);

CREATE TABLE УЧАСТНИК
(
    ID            INTEGER PRIMARY KEY,
    ID_КОМАНДА    INTEGER      NOT NULL,
    ИМЯ           VARCHAR(256) NOT NULL,
    ВОЗРАСТ       INTEGER      NOT NULL,
    ИГРОВОЙ_НОМЕР INTEGER      NOT NULL CHECK ( ИГРОВОЙ_НОМЕР > 0 AND ИГРОВОЙ_НОМЕР < 6),
    РОЛЬ          РОЛЬ         NOT NULL,
    РЕГИОН        VARCHAR(256) NOT NULL,
    FOREIGN KEY (ID_КОМАНДА) REFERENCES КОМАНДА (ID)
);



CREATE TABLE СОТРУДНИК
(
    ID        INTEGER PRIMARY KEY,
    ФИО       VARCHAR(256) NOT NULL,
    ДОЛЖНОСТЬ ДОЛЖНОСТЬ    NOT NULL,
    ЗАРПЛАТА  INTEGER      NOT NULL
);


CREATE TABLE СОТРУДНИК_МАТЧА
(
    ID_СОТРУДНИКА INTEGER NOT NULL,
    ID_МАТЧА      INTEGER NOT NULL,
    FOREIGN KEY (ID_СОТРУДНИКА) REFERENCES СОТРУДНИК (ID),
    FOREIGN KEY (ID_МАТЧА) REFERENCES МАТЧ (ID)
);


CREATE TABLE БИЛЕТ
(
    ID         serial  PRIMARY KEY,
    МЕСТО       INTEGER NOT NULL,
    ID_МАТЧА   INTEGER NOT NULL,
    ПРИВИЛЕГИЯ ПРИВИЛЕГИЯ NOT NULL,
    FOREIGN KEY (ID_МАТЧА) REFERENCES МАТЧ (ID)
);


CREATE TABLE ЭНД
(
    ID            INTEGER PRIMARY KEY,
    ID_МАТЧА      INTEGER NOT NULL,
    FOREIGN KEY (ID_МАТЧА) REFERENCES МАТЧ (ID)
);

CREATE TABLE БРОСОК
(

    ID        INTEGER PRIMARY KEY,
    ID_ИГРОКА INTEGER NOT NULL,
    ID_ЭНДА   INTEGER NOT NULL,
    РЕЗУЛЬТАТ INTEGER NOT NULL,
    FOREIGN KEY (ID_ЭНДА) REFERENCES ЭНД (ID),
    FOREIGN KEY (ID_ИГРОКА) REFERENCES УЧАСТНИК (ID)
);

CREATE TABLE СОБЫТИЕ
(
    ID          INTEGER PRIMARY KEY,
    ТИП_СОБЫТИЯ ТИП_СОБЫТИЯ NOT NULL,
    ID_ЭНДА     INTEGER     NOT NULL,
    ВРЕМЯ       DATE        NOT NULL,
    FOREIGN KEY (ID_ЭНДА) REFERENCES ЭНД (ID)
);


SELECT МАТЧ.ID as МАТЧ_ID, К.НАЗВАНИЕ as НАЗВАНИЕ_КОМАНДЫ, Э.ID as ID_ЭНДА, sum(Б.РЕЗУЛЬТАТ) as СУММА_БРОСКОВ_ЗА_ЭНД FROM МАТЧ
    JOIN ЭНД Э on МАТЧ.ID = Э.ID_МАТЧА
    JOIN БРОСОК Б on Э.ID = Б.ID_ЭНДА join УЧАСТНИК У on Б.ID_ИГРОКА = У.ID
    join КОМАНДА К on У.ID_КОМАНДА = К.ID GROUP BY МАТЧ.ID, Э.ID, К.НАЗВАНИЕ order by МАТЧ_ID, Э.ID;
