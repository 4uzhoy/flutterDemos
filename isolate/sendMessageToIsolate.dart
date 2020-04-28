//
// Метод, который отправляет сообщение новому изоляту
// и получает ответ
// 
// В этом примере рассматриваем "общение"
// посредством класса String (отправка и получение данных)
//
Future<String> sendReceive(String messageToBeSent) async {
    //
    // Временный порт для получения ответа
    //
    ReceivePort port = ReceivePort();

    //
    // Отправляем сообщение изоляту, а также
    // говорим изоляту, какой порт использовать
    // для отправки ответа
    //
    newIsolateSendPort.send(
        CrossIsolatesMessage<String>(
            sender: port.sendPort,
            message: messageToBeSent,
        )
    );

    //
    // Ждём ответ и возвращаем его
    //
    return port.first;
}

//
// Callback-функция для обработки входящего сообщения
//
static void callbackFunction(SendPort callerSendPort){
    //
    // Создаём экземпляр SendPort для получения сообщения
    // от вызывающего
    //
    ReceivePort newIsolateReceivePort = ReceivePort();

    //
    // Даём "вызывающему" ссылку на SendPort ЭТОГО изолята
    //
    callerSendPort.send(newIsolateReceivePort.sendPort);

    //
    // Функция изолята, которая слушает входящие сообщения,
    // обрабатывает и отправляет ответ
    //
    newIsolateReceivePort.listen((dynamic message){
        CrossIsolatesMessage incomingMessage = message as CrossIsolatesMessage;

        //
        // Обработка сообщения
        //
        String newMessage = "complemented string " + incomingMessage.message;

        //
        // Отправляем результат обработки
        //
        incomingMessage.sender.send(newMessage);
    });
}

//
// Вспомогательный класс
//
class CrossIsolatesMessage<T> {
    final SendPort sender;
    final T message;

    CrossIsolatesMessage({
        @required this.sender,
        this.message,
    });
}
