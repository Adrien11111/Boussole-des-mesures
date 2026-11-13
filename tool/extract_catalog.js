// One-shot: extrait THEMES + M de legacy/index.html vers assets/measures.json
const fs = require('fs');
const html = fs.readFileSync('legacy/index.html', 'utf8');
const script = html.match(/<script>([\s\S]*?)<\/script>/)[1];
const code = script.split('//#logic-end')[0].replace('//#logic-start', '');
const { THEMES, M } = new Function(code + ';return {THEMES, M};')();
fs.writeFileSync('assets/measures.json', JSON.stringify({
  themes: THEMES,
  measures: M.map(({ id, no, theme, text, phare, info }) => ({ id, no, theme, text, phare, info })),
}));
console.log('measures:', M.length);
