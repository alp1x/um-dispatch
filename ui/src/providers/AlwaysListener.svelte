<script lang="ts">
	import { ReceiveNUI } from '@utils/ReceiveNUI'
	import { DISPATCH_MENU, DISPATCH, PLAYER, Locale, RESPOND_KEYBIND, MAX_CALL_LIST, shortCalls } from '@store/stores';

	ReceiveNUI('newCall', (data: any) => {
		DISPATCH.update(dispatches => {
			dispatches = dispatches || [];
			dispatches.push(data);
			return dispatches;
		});
	});

	ReceiveNUI('setDispatchs', (data: any) => {
		DISPATCH_MENU.set(data)
	});

	ReceiveNUI('setupUI', (data: any) => {
		PLAYER.set(data.player)
		Locale.set(data.locales)
		RESPOND_KEYBIND.set(data.keybind)
		MAX_CALL_LIST.set(data.maxCallList)
		shortCalls.set(data.shortCalls)
	});
</script>
