<script>
	import { onDestroy } from 'svelte'
	import { SvelteMap } from 'svelte/reactivity'
	import { get } from 'svelte/store'
	import {
		DISPATCH,
		removeDispatch,
		RESPOND_KEYBIND,
		IS_RIGHT_MARGIN,
		shortCalls,
	} from '@store/stores'
	import { fly } from 'svelte/transition'
	import DispatchCard from '@components/DispatchCard.svelte'

	let notifications = $state([])
	const notificationTimeouts = new SvelteMap()

	const unsubscribeDispatch = DISPATCH.subscribe((value) => {
		notifications = value || []
		syncNotificationTimeouts()
	})

	function scheduleNotificationRemoval(notification) {
		const dispatchId = notification?.data?.id
		const timer = notification?.timer

		if (
			dispatchId == null ||
			timer == null ||
			notificationTimeouts.has(dispatchId)
		) {
			return
		}

		const timeoutId = setTimeout(() => {
			notificationTimeouts.delete(dispatchId)
			removeDispatch(dispatchId)
		}, timer)

		notificationTimeouts.set(dispatchId, timeoutId)
	}

	function syncNotificationTimeouts() {
		for (const notification of notifications) {
			scheduleNotificationRemoval(notification)
		}

		const activeIds = new Set(notifications.map((n) => n?.data?.id))

		for (const [id, timeoutId] of notificationTimeouts.entries()) {
			if (!activeIds.has(id)) {
				clearTimeout(timeoutId)
				notificationTimeouts.delete(id)
			}
		}
	}

	onDestroy(() => {
		unsubscribeDispatch()
		for (const timeoutId of notificationTimeouts.values()) {
			clearTimeout(timeoutId)
		}
		notificationTimeouts.clear()
	})

	function getFields(dispatch) {
		if (get(shortCalls)) {
			return [
				{ label: 'Call', value: dispatch.data.message },
				{ label: 'Street', value: dispatch.data.street },
			]
		}
		return [
			{ label: 'Information', value: dispatch.data.information },
			{ label: 'Distance', value: dispatch.data.distance },
			{ label: 'Person', value: dispatch.data.person || dispatch.data.name },
			{ label: 'Gender', value: dispatch.data.gender },
			{ label: 'Vehicle', value: dispatch.data.vehicle },
		]
	}
</script>

<div
	class="flex h-screen w-screen items-start justify-end px-3 pb-3 pt-3 {$IS_RIGHT_MARGIN
		? 'flex-row'
		: 'flex-row-reverse'}"
>
	<div class="mt-[16vh] flex w-[342px] flex-col gap-1.5">
		{#each notifications.slice().reverse() as dispatch, index (dispatch.data.id)}
			<div
				transition:fly={{ x: $IS_RIGHT_MARGIN ? 400 : -400, duration: 220 }}
			>
				<DispatchCard
					dispatch={dispatch.data}
					fields={getFields(dispatch)}
					respondKey={index === 0 ? $RESPOND_KEYBIND : null}
				/>
			</div>
		{/each}
	</div>
</div>
