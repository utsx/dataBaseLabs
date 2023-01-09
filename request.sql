SELECT К.НАЗВАНИЕ, COUNT(Б.ID) as Количество_бросков FROM КОМАНДА К JOIN КОМАНДА_В_МАТЧЕ КВМ ON
    КВМ.ID_КОМАНДА = К.ID JOIN МАТЧ М ON КВМ.ID_МАТЧ = М.ID JOIN ЭНД Э ON М.ID = Э.ID_МАТЧА
    JOIN БРОСОК Б ON Б.ID_ЭНДА = Э.ID JOIN УЧАСТНИК У ON У.ID = Б.id_ИГРОКА AND У.id_КОМАНДА = К.ID
    JOIN ПРОТОКОЛ_МАТЧА ПМ ON ПМ.ID_ПОБЕДИТЕЛЯ = К.ID GROUP BY
    К.НАЗВАНИЕ ORDER BY COUNT(Б.ID) DESC;

-- Для всех команд которые хоть раз побеждали,
-- вывести название команды и число бросков во всех матчах в которых они побеждали


explain ANALYSE SELECT К.НАЗВАНИЕ, COUNT(Б.ID) FROM КОМАНДА К JOIN КОМАНДА_В_МАТЧЕ КВМ ON
    КВМ.ID_КОМАНДА = К.ID JOIN МАТЧ М ON КВМ.ID_МАТЧ = М.ID JOIN ЭНД Э ON М.ID = Э.ID_МАТЧА
    JOIN БРОСОК Б ON Б.ID_ЭНДА = Э.ID JOIN УЧАСТНИК У ON У.ID = Б.id_ИГРОКА AND У.id_КОМАНДА = К.ID
    JOIN ПРОТОКОЛ_МАТЧА ПМ ON ПМ.ID_ПОБЕДИТЕЛЯ = К.ID GROUP BY
    К.НАЗВАНИЕ ORDER BY COUNT(Б.ID) DESC;


SELECT relname, reltuples
FROM pg_class WHERE relname='БИЛЕТ' OR relname='ОРГАНИЗАЦИЯ' OR relname='СТАДИОН'
OR relname='ТУРНИР' OR relname='БРОСОК' OR relname='ГРУППА' OR relname='КОМАНДА'
OR relname='КОМАНДА_В_МАТЧЕ' OR relname='МАТЧ' OR relname='ПРОТОКОЛ_МАТЧА'
OR relname='УЧАСТНИК' OR relname='ЭНД' OR relname='УЧАСТНИК' OR relname='ПРАВИЛО'
OR relname='СОТРУДНИК' OR relname='СОТРУДНИК_МАТЧА' OR relname='РЕГЛАМЕНТ' OR relname='ПРАВИЛО_В_РЕГЛАМЕНЕТЕ' OR relname='СОБЫТИЕ';

SELECT К.НАЗВАНИЕ, COUNT(Б.ID) as Количество_бросков FROM КОМАНДА К JOIN КОМАНДА_В_МАТЧЕ КВМ ON
    КВМ.ID_КОМАНДА = К.ID JOIN МАТЧ М ON КВМ.ID_МАТЧ = М.ID JOIN ЭНД Э ON М.ID = Э.ID_МАТЧА
    JOIN БРОСОК Б ON Б.ID_ЭНДА = Э.ID JOIN УЧАСТНИК У ON У.ID = Б.id_ИГРОКА AND У.id_КОМАНДА = К.ID
    JOIN ПРОТОКОЛ_МАТЧА ПМ ON ПМ.ID_ПОБЕДИТЕЛЯ = К.ID WHERE К.НАЗВАНИЕ LIKE 'Сборная ИТМО %' GROUP BY
    К.НАЗВАНИЕ ORDER BY COUNT(Б.ID) DESC;

SELECT МАТЧ.ID, COUNT(ЭНД.ID) FROM МАТЧ JOIN ЭНД ON ЭНД.ID_МАТЧА = МАТЧ.ID GROUP BY МАТЧ.ID ORDER BY COUNT(ЭНД.ID);
