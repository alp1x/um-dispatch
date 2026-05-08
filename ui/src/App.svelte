<script lang="ts">
	import VisibilityProvider from '@providers/VisibilityProvider.svelte'
	import { Locale } from '@store/stores'
	import AlwaysListener from '@providers/AlwaysListener.svelte'
	import Menu from '@components/Menu.svelte'
	import Main from '@components/Main.svelte'
</script>

{#if $Locale}
	<VisibilityProvider>
		<Menu />
	</VisibilityProvider>

	<Main />
{/if}

<AlwaysListener />
