import { mount } from 'svelte'
import App from './App.svelte'
import '@fortawesome/fontawesome-free/css/all.min.css'
import '../style.css'

const app = mount(App, {
  target: document.getElementById('app')!,
})

export default app