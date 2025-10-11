# 💕 Bebe Água Mulher

Um aplicativo Flutter romântico e delicado para lembrar de beber água, criado com muito amor e carinho.

## 🌟 Funcionalidades

### 💧 Configuração de Hidratação
- **Meta diária personalizada**: Defina a quantidade de água que deseja beber por dia (1L a 4L)
- **Intervalos personalizados**: Configure lembretes a cada 15 minutos até 3 horas
- **Horário de funcionamento**: Defina horário de início e fim dos lembretes
- **Tamanho do copo**: Configure o tamanho padrão do seu copo

### 🔔 Notificações Românticas
- **Mensagens carinhosas**: Notificações com frases de amor e cuidado
- **Sons suaves**: Sons românticos como sinos, harpa ou batidas de coração
- **Vibração delicada**: Vibração suave para não assustar
- **Mensagem personalizada**: Crie sua própria mensagem de amor

### 💖 Interface Romântica
- **Tema delicado**: Cores em tons de rosa, lilás e azul claro
- **Animações suaves**: Corações pulsantes, gotas caindo, efeitos românticos
- **Frases carinhosas**: Mensagens de amor espalhadas pela interface
- **Design responsivo**: Funciona perfeitamente em qualquer dispositivo

### 📊 Histórico e Progresso
- **Visualização diária**: Veja seu progresso com barras de corações
- **Estatísticas semanais**: Resumo da sua hidratação da semana
- **Gráficos românticos**: Visualização do progresso com cores suaves
- **Metas atingidas**: Celebração quando você atinge sua meta!

### 🎨 Recursos Especiais
- **Tela de boas-vindas**: Mensagem personalizada na primeira vez
- **Lembrete em tela cheia**: Animação romântica quando o celular está desbloqueado
- **Widget para tela inicial**: Acesso rápido ao progresso
- **Configurações avançadas**: Personalize sons, vibração e mensagens

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework principal
- **Notificações**: `flutter_local_notifications`
- **Armazenamento**: `shared_preferences`
- **Animações**: `flutter_animate`, `lottie`
- **Navegação**: `go_router`
- **Estado**: `provider`
- **Sons**: `audioplayers`
- **Vibração**: `vibration`
- **Data/Hora**: `intl`

## 🚀 Como Executar

1. **Clone o repositório**
   ```bash
   git clone [url-do-repositorio]
   cd bebe_agua_mulher
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo**
   ```bash
   flutter run
   ```

## 📱 Telas do Aplicativo

### 🏠 Tela Inicial
- Progresso diário com animação de garrafa
- Botões para adicionar água rapidamente
- Frase motivacional do dia
- Estatísticas do dia

### 💕 Tela de Boas-vindas
- Mensagem romântica personalizada
- Animação de coração pulsante
- Configuração inicial opcional

### ⚙️ Configurações
- Meta diária de água
- Intervalo entre lembretes
- Horário de funcionamento
- Configurações de notificação
- Mensagem personalizada

### 📈 Histórico
- Resumo semanal
- Gráfico de barras romântico
- Lista de dias com progresso
- Estatísticas detalhadas

### 🔔 Lembrete
- Tela cheia com animação
- Coração pulsante
- Mensagem romântica
- Botão "Já bebi água!"
- Vibração e sons suaves

## 🎨 Paleta de Cores

- **Rosa Principal**: `#E91E63`
- **Rosa Claro**: `#F8BBD9`
- **Rosa Suave**: `#FCE4EC`
- **Lavanda**: `#E1BEE7`
- **Lavanda Claro**: `#F3E5F5`
- **Azul Claro**: `#B3E5FC`
- **Azul Suave**: `#E3F2FD`

## 💝 Frases Românticas

O aplicativo inclui 10 frases carinhosas que aparecem aleatoriamente:

- "Cuidar de você é meu maior gesto de amor 💖"
- "Sua hidratação é minha prioridade 💧❤️"
- "Cada gota de água é um ato de amor próprio 🌸"
- "Você merece todo cuidado do mundo 💕"
- E mais 6 frases especiais!

## 🔧 Configurações Avançadas

### Notificações
- Ativar/desativar lembretes
- Som personalizado
- Vibração configurável
- Mensagem personalizada

### Interface
- Tema romântico fixo
- Animações suaves
- Cores delicadas
- Fontes elegantes

## 📦 Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada
├── models/                   # Modelos de dados
│   ├── hydration_settings.dart
│   └── water_intake.dart
├── screens/                  # Telas do aplicativo
│   ├── welcome_screen.dart
│   ├── home_screen.dart
│   ├── settings_screen.dart
│   ├── history_screen.dart
│   └── reminder_screen.dart
├── widgets/                  # Widgets personalizados
│   ├── water_progress_widget.dart
│   ├── water_intake_button.dart
│   ├── daily_stats_widget.dart
│   └── home_widget.dart
├── services/                 # Serviços
│   ├── storage_service.dart
│   └── notification_service.dart
├── theme/                    # Tema e cores
│   └── app_theme.dart
└── utils/                    # Utilitários
```

## 🎯 Próximas Funcionalidades

- [ ] Integração com Apple Health / Google Fit
- [ ] Temas adicionais (outono, inverno, primavera)
- [ ] Lembretes baseados em localização
- [ ] Compartilhamento de progresso
- [ ] Desafios de hidratação
- [ ] Lembretes para parceiro/parceira

## 💖 Feito com Amor

Este aplicativo foi criado com muito carinho e amor, pensando em ajudar pessoas a se hidratarem melhor enquanto recebem mensagens românticas e cuidados especiais.

**Desenvolvido com 💕 para quem você ama!**

---

*"Cada gota de água é um gesto de amor próprio"* 💧❤️

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
