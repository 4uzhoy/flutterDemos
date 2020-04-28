//
// Порт нового изолята
// этот порт будет использован для
// отправки сообщений этому изоляту
//
SendPort newIsolateSendPort;

//
// Экземпляр нового изолята
//
Isolate newIsolate;

//
// Метод, который запускает новый изолят
// и процесс рукопожатия
//
void callerCreateIsolate() async {
    //
    // Локальный временный ReceivePort для получения
    // SendPort нового изолята
    //
    ReceivePort receivePort = ReceivePort();

    //
    // Создание экземпляра изолята
    //
    newIsolate = await Isolate.spawn(
        callbackFunction,
        receivePort.sendPort,
    );

    //
    // Запрос порта для организации "общения"
    //
    newIsolateSendPort = await receivePort.first;
}

//
// Точка входа нового изолята
// Важное ограничение: входной точкой Изолята ДОЛЖНА БЫТЬ функция верхнего уровня или СТАТИЧЕСКИЙ метод класса

static void callbackFunction(SendPort callerSendPort){
    //
    // Создание экземпляра SendPort для получения сообщений
    // от "вызывающего"
    //
    ReceivePort newIsolateReceivePort = ReceivePort();

    //
    // Даём "вызывающему" ссылку на SendPort ЭТОГО изолята
    //
    callerSendPort.send(newIsolateReceivePort.sendPort);

    //
    // Дальнейшая работа
    //
}
