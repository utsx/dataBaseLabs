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