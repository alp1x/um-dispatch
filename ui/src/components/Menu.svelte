<script>
	import {
		PLAYER,
		Locale,
		DISPATCH_MENU,
		DISPATCH_MUTED,
		DISPATCH_DISABLED,
		IS_RIGHT_MARGIN,
		processedDispatchMenu,
	} from '@store/stores'
	import { fly, slide } from 'svelte/transition'
	import { timeAgo } from '@utils/timeAgo'
	import { SendNUI } from '@utils/SendNUI'
	import DispatchCard from '@components/DispatchCard.svelte'
	import Clock from 'lucide-svelte/icons/clock'
	import MapPin from 'lucide-svelte/icons/map-pin'
	import Info from 'lucide-svelte/icons/info'
	import Route from 'lucide-svelte/icons/route'
	import User from 'lucide-svelte/icons/user'
	import Shield from 'lucide-svelte/icons/shield'
	import Car from 'lucide-svelte/icons/car'
	import Contact from 'lucide-svelte/icons/contact'
	import Users from 'lucide-svelte/icons/users'
	import Circle from 'lucide-svelte/icons/circle'
	import RefreshCw from 'lucide-svelte/icons/refresh-cw'
	import Volume2 from 'lucide-svelte/icons/volume-2'
	import VolumeX from 'lucide-svelte/icons/volume-x'
	import Bell from 'lucide-svelte/icons/bell'
	import BellOff from 'lucide-svelte/icons/bell-off'
	import Ban from 'lucide-svelte/icons/ban'
	import ArrowLeft from 'lucide-svelte/icons/arrow-left'
	import ArrowRight from 'lucide-svelte/icons/arrow-right'

	let activeCallId = $state(null)
	let additionalUnitsVisible = $state({})

	function toggleDispatch(id) {
		activeCallId = activeCallId === id ? null : id
	}

	function isAttached(units, player) {
		return units.some((u) => u.citizenid === player)
	}

	function toggleAdditionalUnits(callId) {
		additionalUnitsVisible[callId] = !additionalUnitsVisible[callId]
	}

	function additionalCount(dispatch) {
		return Math.max(0, dispatch.units.length - 3)
	}

	function toggleMargin() {
		IS_RIGHT_MARGIN.update((v) => !v)
	}

	function toggleMute() {
		DISPATCH_MUTED.update((v) => !v)
		SendNUI('toggleMute', { boolean: $DISPATCH_MUTED })
	}

	function toggleAlerts() {
		DISPATCH_DISABLED.update((v) => !v)
		SendNUI('toggleAlerts', { boolean: $DISPATCH_DISABLED })
	}

	function t(key, fallback) {
		return $Locale?.[key] ?? fallback
	}

	function jobTint(jobType) {
		if (jobType === 'leo') return 'border-blue-400/50 text-blue-200'
		if (jobType === 'ems') return 'border-red-400/50 text-red-200'
		return 'border-zinc-500/50 text-zinc-300'
	}

	const detailIcons = {
		Time: Clock,
		Street: MapPin,
		Information: Info,
		Location: MapPin,
		Distance: Route,
		Person: User,
		Weapon: Shield,
		Vehicle: Car,
		Plate: Contact,
		Units: Users,
	}

	function getDetailIcon(label) {
		return detailIcons[label] || Circle
	}

	function shouldRender(value) {
		if (value == null) return false
		if (typeof value === 'string') {
			const v = value.trim().toLowerCase()
			if (!v || v === 'unknown') return false
		}
		return true
	}

	function getCompactFields(dispatch) {
		return [
			{ label: 'Street', value: dispatch.street || dispatch.location },
			{ label: 'Information', value: dispatch.information },
			{ label: 'Distance', value: dispatch.distance },
			{ label: 'Person', value: dispatch.person || dispatch.name },
			{ label: 'Gender', value: dispatch.gender },
			{ label: 'Vehicle', value: dispatch.vehicle },
		]
	}

	function getDetailFields(dispatch) {
		return [
			{ label: 'Time', value: timeAgo(dispatch.time) },
			{ label: 'Street', value: dispatch.street },
			{ label: 'Location', value: dispatch.location },
			{ label: 'Distance', value: dispatch.distance },
			{ label: 'Information', value: dispatch.information },
			{ label: 'Person', value: dispatch.person || dispatch.name },
			{ label: 'Gender', value: dispatch.gender },
			{ label: 'Weapon', value: dispatch.weapon },
			{ label: 'Vehicle', value: dispatch.vehicle },
			{ label: 'Plate', value: dispatch.plate },
			{ label: 'Units', value: dispatch.units.length },
		]
	}

	const MuteIcon = $derived($DISPATCH_MUTED ? VolumeX : Volume2)
	const AlertIcon = $derived($DISPATCH_DISABLED ? BellOff : Bell)
	const MarginIcon = $derived($IS_RIGHT_MARGIN ? ArrowLeft : ArrowRight)
</script>

<div
	class="flex h-screen w-screen items-center justify-end p-3 {$IS_RIGHT_MARGIN
		? 'flex-row'
		: 'flex-row-reverse'}"
	transition:fly={{ x: $IS_RIGHT_MARGIN ? 400 : -400 }}
>
	<!-- CONTROLS -->
	<div class="flex w-8 flex-col gap-1">
		<button
			class="flex h-7 w-full items-center justify-center rounded-md border border-white/10 bg-zinc-900/85 text-zinc-400 transition-colors hover:border-white/20 hover:text-zinc-100"
			aria-label={t('ui_refresh_alerts', 'Refresh alerts')}
			title={t('ui_refresh_alerts', 'Refresh alerts')}
			onclick={() => SendNUI('refreshAlerts')}
		>
			<RefreshCw class="h-3.5 w-3.5" />
		</button>
		<button
			class="flex h-7 w-full items-center justify-center rounded-md border border-white/10 bg-zinc-900/85 text-zinc-400 transition-colors hover:border-white/20 hover:text-zinc-100"
			aria-label={$DISPATCH_MUTED
				? t('ui_unmute_alerts', 'Unmute alerts')
				: t('ui_mute_alerts', 'Mute alerts')}
			title={$DISPATCH_MUTED
				? t('ui_unmute_alerts', 'Unmute alerts')
				: t('ui_mute_alerts', 'Mute alerts')}
			onclick={toggleMute}
		>
			<MuteIcon class="h-3.5 w-3.5" />
		</button>
		<button
			class="flex h-7 w-full items-center justify-center rounded-md border border-white/10 bg-zinc-900/85 text-zinc-400 transition-colors hover:border-white/20 hover:text-zinc-100"
			aria-label={$DISPATCH_DISABLED
				? t('ui_enable_alerts', 'Enable alerts')
				: t('ui_disable_alerts', 'Disable alerts')}
			title={$DISPATCH_DISABLED
				? t('ui_enable_alerts', 'Enable alerts')
				: t('ui_disable_alerts', 'Disable alerts')}
			onclick={toggleAlerts}
		>
			<AlertIcon class="h-3.5 w-3.5" />
		</button>
		<button
			class="flex h-7 w-full items-center justify-center rounded-md border border-white/10 bg-zinc-900/85 text-zinc-400 transition-colors hover:border-white/20 hover:text-zinc-100"
			aria-label={t('ui_clear_blips', 'Clear blips')}
			title={t('ui_clear_blips', 'Clear blips')}
			onclick={() => SendNUI('clearBlips')}
		>
			<Ban class="h-3.5 w-3.5" />
		</button>
		<button
			class="flex h-7 w-full items-center justify-center rounded-md border border-white/10 bg-zinc-900/85 text-zinc-400 transition-colors hover:border-white/20 hover:text-zinc-100"
			aria-label={$IS_RIGHT_MARGIN
				? t('ui_move_menu_left', 'Move menu to left')
				: t('ui_move_menu_right', 'Move menu to right')}
			title={$IS_RIGHT_MARGIN
				? t('ui_move_menu_left', 'Move menu to left')
				: t('ui_move_menu_right', 'Move menu to right')}
			onclick={toggleMargin}
		>
			<MarginIcon class="h-3.5 w-3.5" />
		</button>
	</div>

	<!-- MENU -->
	<div
		class="ml-2 mr-2 flex h-[90%] w-[340px] flex-col gap-2 overflow-y-auto pr-1"
	>
		{#if $DISPATCH_MENU}
			{#each $processedDispatchMenu as dispatch (dispatch.id)}
				<div class="flex flex-col gap-1">
					<button
						class="block w-full bg-transparent p-0 text-left"
						onclick={() => toggleDispatch(dispatch.id)}
					>
						<DispatchCard
							{dispatch}
							fields={getCompactFields(dispatch)}
						/>
					</button>

					{#if activeCallId === dispatch.id}
						<div class="flex flex-col gap-1" transition:slide={{ duration: 200 }}>
							<div
								class="rounded-lg border border-white/10 bg-zinc-900/70 px-3 py-2"
							>
								<div
									class="mb-1 text-[10px] font-semibold uppercase tracking-wider text-zinc-500"
								>
									{t('ui_details', 'Details')}
								</div>
								<div class="flex flex-col gap-1 text-xs text-zinc-300">
									{#each getDetailFields(dispatch) as field (field.label)}
										{#if shouldRender(field.value)}
											{@const Icon = getDetailIcon(field.label)}
											<div
												class="flex items-center gap-2 rounded bg-white/5 px-2 py-0.5"
											>
												<Icon class="h-3 w-3 shrink-0 text-zinc-500" />
												<span class="line-clamp-1">{field.value}</span>
											</div>
										{/if}
									{/each}
								</div>
							</div>

							{#if dispatch.units.length > 0}
								<div class="flex flex-col gap-1">
									{#each dispatch.units.slice(0, additionalUnitsVisible[dispatch.id] ? dispatch.units.length : 3) as unit (unit.citizenid)}
										<div
											class="flex h-9 w-full items-center gap-2 rounded-lg border border-white/10 bg-zinc-900/70 px-2 text-xs text-zinc-200"
										>
											<span
												class="rounded-md bg-zinc-800 px-2 py-0.5 font-semibold"
											>
												{unit.metadata.callsign}
											</span>
											<span
												class="rounded-md border bg-zinc-900/40 px-2 py-0.5 text-[10px] font-semibold uppercase {jobTint(
													unit.job.type,
												)}"
											>
												{unit.job.name}
											</span>
											<span class="line-clamp-1 text-zinc-300">
												{unit.charinfo.firstname} {unit.charinfo.lastname}
											</span>
										</div>
									{/each}
									{#if dispatch.units.length > 3 && !additionalUnitsVisible[dispatch.id]}
										<button
											class="flex h-7 w-full items-center justify-center rounded-md border border-white/10 bg-zinc-900/60 text-xs font-semibold text-zinc-300 transition-colors hover:border-white/20 hover:text-zinc-100"
											onclick={() => toggleAdditionalUnits(dispatch.id)}
										>
											+{additionalCount(dispatch)} {$Locale.additionals}
										</button>
									{/if}
								</div>
							{/if}

							<button
								class="flex h-9 w-full items-center gap-2 rounded-lg border border-white/10 bg-zinc-900/70 px-2 text-xs font-semibold text-zinc-100 transition-colors hover:border-white/20"
								onclick={() => {
									if (isAttached(dispatch.units, $PLAYER.citizenid)) {
										SendNUI('detachUnit', dispatch)
									} else {
										SendNUI('attachUnit', dispatch)
									}
									SendNUI('refreshAlerts')
								}}
							>
								<span class="rounded-md bg-zinc-800 px-2 py-0.5">
									{dispatch.units.length} {$Locale.units}
								</span>
								<span>
									{isAttached(dispatch.units, $PLAYER.citizenid)
										? $Locale.dispatch_detach
										: $Locale.dispatch_attach}
								</span>
							</button>
						</div>
					{/if}
				</div>
			{/each}
		{/if}
	</div>
</div>
