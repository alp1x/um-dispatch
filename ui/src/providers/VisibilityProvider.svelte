<script lang="ts">
	import { ReceiveNUI } from '../utils/ReceiveNUI'
	import { SendNUI } from '../utils/SendNUI'
	import { onMount } from 'svelte'
	import { get } from 'svelte/store'
	import { VISIBILITY } from '../store/stores'
	let { children } = $props()

	ReceiveNUI<boolean>('setVisible', (visible: boolean) => {
		VISIBILITY.set(visible)
	})

	onMount(() => {
		const keyHandler = (e: KeyboardEvent) => {
			if (e.code !== 'Escape') return
			if (!get(VISIBILITY)) return

			SendNUI('hideUI')
			VISIBILITY.set(false)
		}

		window.addEventListener('keydown', keyHandler)

		return () => window.removeEventListener('keydown', keyHandler)
	})
</script>

{#if $VISIBILITY}
	<main>
		{@render children?.()}
	</main>
{/if}

<style>
	main {
		position: absolute;
		left: 0;
		top: 0;
		z-index: 100;
		user-select: none;
		box-sizing: border-box;
		padding: 0;
		margin: 0;
		height: 100vh;
		width: 100vw;
	}
</style>
