# **Controle Remoto - App Flutter**

Este projeto é o aplicativo móvel que funciona como cliente para o servidor **Python** e permite controlar o computador remotamente. Com o app, é possível ajustar o volume, mover o mouse, realizar cliques (esquerdo/direito) e rolar o scroll diretamente do seu smartphone.

---

## **Índice**

- [Funcionalidades](#funcionalidades)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Como Compilar e Executar](#como-compilar-e-executar)

---

## **Funcionalidades**

- **Controle de Volume**: Aumentar ou diminuir o volume do computador com um slider.
- **Controle do Mouse**:
  - Movimentação precisa através de um joystick.
  - Botões para clique esquerdo e direito.
  - Controle de scroll para cima e para baixo.
- **Autorização por QR Code**:
  - Escaneie o QR Code gerado pelo servidor para conectar automaticamente ao computador.

---

## **Tecnologias Utilizadas**

- **Framework**: Flutter.
- **Bibliotecas Principais**:
  - `mobile_scanner`: Para escanear o QR Code gerado pelo servidor.
  - `flutter_joystick`: Para controle do movimento do mouse.
  - `http`: Para comunicação com o servidor.

---

## **Como Compilar e Executar**

1. **Clone o repositório**:
   ```bash
   git clone https://github.com/seu-usuario/seu-repositorio.git](https://github.com/becastellani/Flutter-RemoteMouse
   ```

2. **Instale as dependências do Flutter**
```bash
  flutter pub get
```

3. **Faça o build do APK **
```bash
 flutter build apk --release
```

---

## **Melhorias Futuras**

- Implementar mais funcionalidades de controle, como:
  - Controle de teclado.
  - Configurações customizáveis no app.
- Melhorar a interface do usuário para torná-la mais intuitiva.
- Adicionar suporte para diferentes sistemas operacionais no servidor.

---

## **Licença e Copyright**

Este projeto foi desenvolvido como uma solução prática e está disponível para aprendizado e aprimoramento. Sinta-se à vontade para utilizar, modificar e compartilhar, desde que seja dado o devido crédito.

**Autor**: [Bernardo Castellani]  
**Copyright** © 2024. Todos os direitos reservados.


