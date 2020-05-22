String getQuestion(int number) {
  switch (number) {
    case 1:
        return '1. Presenta síntomas de gripe como fiebre, tos, falta de aire, o dificultad para respirar?';
    case 2:
        return '2. En su casa hay alguna persona que presente estos síntomas?';
    case 3:
        return '3. Ha permanecido en aislamiento preventivo?';
    case 4:
        return '4. Ha realizado visitas a familiares o amigos durante los ultimos 8 dias?';
    case 5:
        return '5. Ha estado en contacto con mas de 10 personas en un mismo lugar, en los ultimos 8 dias? Ej: Transporte publico, parque , reunion social, etc';
    case 6:
        return 'Declaro que la información que he suministrado en este cuestionario es verídica y que en caso de presentar alguno de los síntomas o de tener contacto con alguna persona contagiada, lo reportaré de manera inmediata al personal encargado.';
    case 7:
        return 'Estoy de acuerdo en reportar, de manera inmediata, si presento alguno de los síntomas indicados en este documento.';
    case 8:
        return 'Estoy de acuerdo en reportar, de manera inmediata, si en mi hogar hay una persona que presente los síntomas indicados en este documento.';
    case 9:
        return 'Estoy de acuerdo en reportar, si durante una ausencia personal o durante mi periodo de vacaciones he presentado alguno de los síntomas.';
    default:
      return '';
  }
}